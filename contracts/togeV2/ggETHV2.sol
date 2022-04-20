// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ggETHV2 is ERC721 {

    address admin;
    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol){}

    
}
