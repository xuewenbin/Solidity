// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Erc721Task2 is ERC721, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => string) private tokenURIs;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}

    function mintNFT(
        address recipient,
        string memory _tokenURI
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(recipient, tokenId);
        tokenURIs[tokenId] = _tokenURI;
        return tokenId;
    }
    //  获取只能合约地址
    function getAddr() public view returns (address) {
        return address(this);
    }

    // function tokenURI(
    //     uint256 tokenId
    // ) public view override returns (string memory) {
    //     // _ownerOf(tokenId) != address(0) 替换 _exists(tokenId)
    //     require(ownerOf(tokenId) != address(0), "Nonexistent token");
    //     return tokenURIs[tokenId];
    // }
}
