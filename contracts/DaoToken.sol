// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DaoToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Szs", "SZS") {
        _mint(msg.sender, initialSupply);
    }
}
