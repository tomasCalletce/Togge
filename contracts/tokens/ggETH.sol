// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GGETH is ERC721 {
    address ggLoan;
    uint valorRetiroLPs;

    mapping(uint256 => uint256) public deposits;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        ggLoan = msg.sender;
    }

    function mint(
        address _account,
        uint256 tokenId,
        uint256 deposit
    ) external {
        require(msg.sender == ggLoan, "ggETH: NOT_ADMIN");
        _mint(_account, tokenId);
        deposits[tokenId] = deposit;
    }

    function withdraw(uint _id,uint _val) external{
        require(ownerOf(_id) == msg.sender,"ggETH: NOT_OWNER");
        uint _deposit = deposits[_id];
        require(_val <= _deposit,"ggETH: NO_ENOUGH_FUNDS");
        deposits[_id] -= _val; 
        valorRetiroLPs += _val;
        payable(msg.sender).transfer(_val);
    }

    function getValorRetiroLPs() external view returns (uint){
        return valorRetiroLPs;
    }
}
