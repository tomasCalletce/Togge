// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract daoToken is ERC20 {

    address admin;

    constructor(
        string memory name,
        string memory symbol,
        address _admin,
        uint _startMint
    )ERC20(name, symbol) {
        admin = _admin;
        _mint(admin,_startMint);
    }

}