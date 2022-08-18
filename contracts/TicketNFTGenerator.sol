// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract TicketNFTGenerator is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable, Pausable {

    enum Rarity { COMMON, RARE, SUPER_RARE }

    string private URL_COMMON = "QmWqkv1i8RcdhuuqwhiewrLwgrsBmm3m6tjdnb3bDoXuhc";
    string private URL_RARE = "QmXGezU1jRBPtSvnyG3D1wPpLhvtD1yYSdWoHzSiEc8v5P";
    string private URL_SUPER_RARE = "QmchhD3zimmerwJMzqeZExCWaTcwKzFpngL3dkapbKSdhW";
    
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private tokenCounter;
    uint256 private maxSupply;
    uint256 private balance;
    uint256 private mintedTokens;
    uint256 public mintPrice;
    string private baseUrl;

    event TicketMinted(address sender, uint256 tokenId, uint256 tokenCounter, uint256 maxSupply);
    event TicketToShow(uint256 tokenId, string tokenUrl);
    event TicketSent(uint256 tokenId, address from, address to);

    constructor(uint256 _maxSupply, uint256 _initialMintPrice) ERC721("TicketNFT", "TKT") {
        maxSupply = _maxSupply;
        mintPrice = _initialMintPrice;
        console.log("Contract instantiated");
    }
    
    /*
     * Pause implementation
     */
    function pause() public onlyOwner() {
        _pause();
    }
    
    function unPause() public onlyOwner() {
        _unpause();
    }
    /*
     * Ovverridden methods for ERC721Enumerable
     */

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
    function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }

    function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(_tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(_tokenId);
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }

    /*
     * Smart contract custom methods
     */
    function mintTicket() public whenNotPaused payable {
        require(msg.value >= mintPrice, "Not enough ETH sent, please check price!"); 

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
        _setTokenURI(tokenId, getTokenUrl(Rarity.COMMON));

        tokenCounter.increment();
        incremenTokenCounter();

        console.log("mintedNfts: %s", mintedTokens);

        emit TicketMinted(msg.sender, tokenId, mintedTokens, maxSupply);

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
    function incremenTokenCounter() private {
        require(mintedTokens < maxSupply, "Mintable nfts have reached maximum supply");
        mintedTokens = mintedTokens.add(1);
    }

    function getTokenUrl(Rarity _rarity) private view returns (string memory) {
        if(_rarity == Rarity.RARE) {
            return URL_RARE;
        } else if(_rarity == Rarity.SUPER_RARE) {
            return URL_SUPER_RARE;
        } else {
            return URL_COMMON;
        }
    }

    receive() external payable {
        receiveMoney();
    }

}
