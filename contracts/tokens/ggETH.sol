// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GGETH is ERC721 {
    address ggLoan;

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
        require(msg.sender == ggLoan, "ggETH:mint | NOT_ADMIN");
        _mint(_account, tokenId);
        deposits[tokenId] = deposit;
    }

    function withdraw(uint256 _id, uint256 _val) external {
        require(msg.sender == ggLoan, "ggETH:withdraw | NOT_ADMIN");
        require(ownerOf(_id) == msg.sender, "ggETH: withdraw | NOT_OWNER");
        uint256 _deposit = deposits[_id];
        require(_val <= _deposit, "ggETH: NO_ENOUGH_FUNDS");
        deposits[_id] -= _val;
    }
}
