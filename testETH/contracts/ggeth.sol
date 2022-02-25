// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ggETH is ERC20 {

    address admin;

    constructor(
        string memory name,
        string memory symbol
    )ERC20(name, symbol) {}


    function mint(address _account, uint256 _amount) external {
        require(msg.sender == admin,"TOGGE::mint: NOT_ADMIN");
        _mint(_account,_amount);
    }

}
