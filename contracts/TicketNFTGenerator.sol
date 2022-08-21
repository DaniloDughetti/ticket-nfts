// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract TicketNFTGenerator is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable, Pausable, VRFConsumerBaseV2 {

    struct ConfigTicket {
        string urlCommon;
        string urlRare;
        string urlSuperRare;

        uint256 upperLimitCommon;
        uint256 upperLimitRare;
        uint256 updatedUpperLimitCommon;
        uint256 updatedUpperLimitRare;
        uint256 randomRangeCommon;
        uint256 randomRangeRare;
    }

    struct ConfigChainLink {
        uint64 subscriptionId;
        address vrfCoordinator;
        bytes32 keyHash;
        uint32 callbackGasLimit;
        uint16 requestConfirmations;
        uint32 wordsNumber;
    }
    //State variables from env
    ConfigTicket private configTicket;
    ConfigChainLink private configChainLink;
    uint256 private maxSupply;
    uint256 public mintPrice;
    
    //Token management state variables
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private tokenCounter;
    uint256 private balance;
    uint256 private mintedTokens;
    string private baseUrl;

    //Chainlink state variables
    VRFCoordinatorV2Interface COORDINATOR;
    mapping(uint256 => address) private requestIdAddresses;
    mapping(address => uint256) private addressRandomValues;
    
    event TicketMinted(address sender, uint256 tokenId, uint256 tokenCounter, uint256 maxSupply);
    event TicketToShow(uint256 tokenId, string tokenUrl);
    event TicketSent(uint256 tokenId, address from, address to);
    event TicketRandomnessGenerated();

    constructor(uint256 _maxSupply, 
    uint256 _initialMintPrice,
    string memory _urlCommon,
    string memory _urlRare,
    string memory _urlSuperRare,
    uint256 _upperLimitCommon,
    uint256 _upperLimitRare,
    uint64 _subscriptionId,
    address _vrfCoordinator,
    bytes32 _keyHash
    ) VRFConsumerBaseV2(configChainLink.vrfCoordinator)
    ERC721("TicketNFT", "TKT")  {
        maxSupply = _maxSupply;
        mintPrice = _initialMintPrice;
        configTicket = ConfigTicket({
            urlCommon: _urlCommon,
            urlRare: _urlRare,
            urlSuperRare: _urlSuperRare,
            upperLimitCommon: _upperLimitCommon,
            upperLimitRare: _upperLimitRare,
            updatedUpperLimitCommon: _upperLimitCommon,
            updatedUpperLimitRare: _upperLimitRare,
            randomRangeCommon: 10, 
            randomRangeRare: 2
        });
        configChainLink = ConfigChainLink({
            subscriptionId: _subscriptionId,
            vrfCoordinator: _vrfCoordinator,
            keyHash: _keyHash,
            callbackGasLimit: 2500000,
            requestConfirmations: 3,
            wordsNumber: 2
        });
        COORDINATOR = VRFCoordinatorV2Interface(configChainLink.vrfCoordinator);
        console.log("Contract instantiated");
    }

    /*
    * Chainlink overrided methods
    */
    function requestRandomWords() external onlyOwner {
        COORDINATOR.requestRandomWords(
            configChainLink.keyHash,
            configChainLink.subscriptionId,
            configChainLink.requestConfirmations,
            configChainLink.callbackGasLimit,
            configChainLink.wordsNumber
        );
    }

    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWords
    ) internal override {
            configTicket.updatedUpperLimitCommon = configTicket.upperLimitCommon + getNormalizedRandomNumber(randomWords[0], configTicket.randomRangeCommon);
            configTicket.updatedUpperLimitRare = configTicket.upperLimitRare + getNormalizedRandomNumber(randomWords[1], configTicket.randomRangeRare);
            emit TicketRandomnessGenerated();
    }
    /*
     * Governance methods
     */
    function pause() public onlyOwner() {
        _pause();
    }
    
    function unPause() public onlyOwner() {
        _unpause();
    }
    /*
     *  RC721Enumerable ovverrided methods
     */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /*
     * Smart contract custom methods
     */
    function mintTicket(uint256 _randomNumber) public whenNotPaused payable {
        require(msg.value >= mintPrice, "Not enough ETH sent, please check price!"); 
        require(_randomNumber >= 0 && _randomNumber <=100, "randomNumber out of range");

        uint256 tokenId = tokenCounter.current();
        
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        /*
         * In this stage passing only Common ticket. Then we will implement Chainlink randomness in order to
         * mint random ticket 
         */
        _safeMint(msg.sender, tokenId);

        uint256 randomWord = 0;
        
        if(addressRandomValues[msg.sender] != 0) {
            randomWord = addressRandomValues[msg.sender];
        }
        
        _setTokenURI(tokenId, getTokenUrl(_randomNumber));

        tokenCounter.increment();
        incremenTokenCounter();

        console.log("mintedNfts: %s", mintedTokens);

        emit TicketMinted(msg.sender, tokenId, mintedTokens, maxSupply);

    }

    function getUpdatedUpperLimitCommon() public view returns(uint256){
        return configTicket.updatedUpperLimitCommon;
    }

    function getUpdatedUpperLimitRare() public view returns(uint256){
        return configTicket.updatedUpperLimitRare;
    }

    function setMintPrice(uint256 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
    }

    function getMintPrice() public whenNotPaused view returns(uint256) {
        return mintPrice;
    }

    function setMaxSupply(uint256 _maxSupply) public whenNotPaused onlyOwner { 
        require(_maxSupply > maxSupply, "New maximum supply must be greater than the previous one");
        maxSupply = _maxSupply;
    }

    function getMaxSupply() public whenNotPaused view returns(uint256) {
        return maxSupply;
    }

    function getTokenCounter() public whenNotPaused view returns(uint256) {
        return tokenCounter.current();
    }

    function getBalance() onlyOwner view public returns(uint256) {
        return balance;
    }

    function givesToken(uint _tokenId, address _to) public {
        transferFrom(msg.sender, _to, _tokenId);
        emit TicketSent(_tokenId, msg.sender, _to);
    }

    function sendMoney(address _to, uint256 _amount) public onlyOwner {
        payable(_to).transfer(_amount);
    }

    function receiveMoney() public payable {
        assert(msg.value.add(balance) >= balance);
        balance = balance.add(msg.value);
    }

    function tokenURIIfOwned(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        if(isTokenOwned(_tokenId)) {
            return super.tokenURI(_tokenId);
        } else {
            return "";
        }
    }

    function isTokenOwned(uint256 _tokenId) public view returns(bool) {
        return _isApprovedOrOwner(msg.sender, _tokenId);
    }
    /*
     * Utility methods
     */
    function incremenTokenCounter() private {
        require(mintedTokens < maxSupply, "Mintable nfts have reached maximum supply");
        mintedTokens = mintedTokens.add(1);
    }
    
    function getNormalizedRandomNumber(uint256 _randomNumber, uint _range) private pure returns(uint256){
        return (_randomNumber % _range) + 1;
    }

    function getTokenUrl(uint256 _randomNumber) private view returns (string memory) {
        if(_randomNumber >= configTicket.updatedUpperLimitCommon && _randomNumber <= configTicket.updatedUpperLimitRare) {
            return configTicket.urlRare;
        } else if(_randomNumber > configTicket.updatedUpperLimitRare) {
            return configTicket.urlSuperRare;
        } else {
            return configTicket.urlCommon;
        }
    }

    receive() external payable {
        receiveMoney();
    }

}
