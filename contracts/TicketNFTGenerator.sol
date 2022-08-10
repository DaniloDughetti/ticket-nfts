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

    string private URL_COMMON = "QmVcoZNRxojq6md86j9Sa7LQbWeXb777kK8LG4gr1AeCMd";
    string private URL_RARE = "QmWhWQa9PaE3W57GnJbYjSguaqjVMhdqZoKC8QmGt92RYP";
    string private URL_SUPER_RARE = "QmRkihMmqSfBmjKts65MQvh7xWwpiwSrFT2cj7B1HDjr7X";
    
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private tokenCounter;
    uint256 private maxSupply;
    uint256 private balance;
    uint256 public mintedTokens;
    string private baseUrl;

    event TicketMinted(address sender, uint256 tokenId, uint256 tokenCounter);
    event TicketToShow(uint256 tokenId, string tokenUrl);

    constructor(uint256 _maxSupply) ERC721("TicketNFT", "TKT") {
        maxSupply = _maxSupply;
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
    function mintTicket(string memory _url) public whenNotPaused {
        uint256 tokenId = tokenCounter.current();
        
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _url);

        tokenCounter.increment();
        incremenTokenCounter();

        console.log("mintedNfts: %s", mintedTokens);

        emit TicketMinted(msg.sender, tokenId, mintedTokens);

    }

    //Emits token owned
    function getNftList() public whenNotPaused {
        uint256 tokenList = balanceOf(msg.sender);
        for(uint i = 0; i < tokenList; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
            emit TicketToShow(tokenId, tokenURI(tokenId));
        }
    }

    function setMaxSupply(uint256 _maxSupply) public whenNotPaused onlyOwner { 
        require(_maxSupply > maxSupply, "New maximum supply must be greater than the previous one");
        maxSupply = _maxSupply;
    }

    function getBalance() onlyOwner view public returns(uint256) {
        return balance;
    }

    function givesToken(uint _tokenId, address _to) public{
        require(isTokenOwned(_tokenId), "You are not the owner of this token");
        transferFrom(msg.sender, _to, _tokenId);
    }

    function sendMoney(address _to, uint256 _amount) public onlyOwner {
        payable(_to).transfer(_amount);
    }

    function receiveMoney() public payable {
        assert(msg.value.add(balance) >= balance);
        balance = balance.add(msg.value);
    }

    function isTokenOwned(uint256 _tokenId) private view returns(bool){
        uint256 tokenList = balanceOf(msg.sender);
        for(uint i = 0; i < tokenList; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
            if(tokenId == _tokenId) {
                return true;
            }
        }
        return false;
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
