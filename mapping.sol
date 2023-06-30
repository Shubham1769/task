// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface AssignmentToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from,address to, uint256 tokenId) external returns (bool);
    function approve(address spender, uint256 amount ) external returns (bool);
}

contract AssignmentNFT is ERC721 {

    AssignmentToken private token;

    mapping(uint256 => uint256) private _token721ToToken20;

    uint public exchangeRate = 1000;

    uint public tokenId;
 
    constructor(string memory name, string memory symbol, address token20Address) ERC721(name, symbol) {
        token = AssignmentToken(token20Address);
    }

    function mintNFT(address to) onlyOwner {
         require(token.balanceOf(msg.sender)>1000*10**18, "You do not have enough tokens");
        _safeMint(to, tokenId);
        _token721ToToken20[tokenId] = exchangeRate;
        token.transferFrom(msg.sender, to, 1000*10**18);
        tokenId++;
    }
    function transferNFT(address to) external {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        require(token.balanceOf(msg.sender)>1000*10**18, "You do not have enough tokens");
        require(balanceOf(msg.sender)>0, "You donot own an NFT");

        address from = msg.sender;
        uint256 token20Amount = _token721ToToken20[tokenId] * 10**18;

        _transfer(from, to, tokenId);
        token.transferFrom(from, to, token20Amount);
    }
    function checkBalance(address _addr) public view returns(uint256){
        return token.balanceOf(_addr);
    }
}
