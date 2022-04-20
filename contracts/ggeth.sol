// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ggETH is ERC721 {

    address ggLoan; 

    mapping(uint => uint) public deposits;

    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol){}

    function mint(address _account,uint tokenId,uint deposit) external {
        require(msg.sender == ggLoan,"ggETH: NOT_ADMIN");
        _mint(_account,tokenId);
        deposits[tokenId] = deposit;
    }
}
