// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract TicketNFTGenerator is ERC721URIStorage, Ownable {
    
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private tokenCounter;
    uint256 private maxSupply;
    uint256 private balance;
    uint256 public mintedTokens;

    event TicketMinted(address sender, uint256 tokenId, uint256 tokenCounter);

    constructor(uint256 _maxSupply) ERC721("TicketNFT", "TKT") {
        maxSupply = _maxSupply;
        console.log("Contract instantiated");
    }

    function mintTicket(string memory _url) public {
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

    /*
    function givesNFT(uint _tokenId, address _to) public{
        transferFrom(msg.sender, _to, _tokenId);
    }

    function getNftList() public {
        uint nftNumber = balanceOf(msg.sender);
    }*/

    function incremenTokenCounter() private {
        require(mintedTokens < maxSupply, "Mintable nfts have reached maximum supply");
        mintedTokens = mintedTokens.add(1);
    }

    function setMaxSupply(uint256 _maxSupply) onlyOwner public{
        require(_maxSupply > maxSupply, "New maximum supply must be greater than the previous one");
        maxSupply = _maxSupply;
    }

    function getBalance() onlyOwner view public returns(uint256) {
        return balance;
    }

    function receiveMoney() public payable {
        assert(msg.value.add(balance) >= balance);
        balance = balance.add(msg.value);
    }

    receive() external payable {
        receiveMoney();
    }
}
