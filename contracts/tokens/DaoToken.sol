// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DaoToken is ERC20 {

    mapping(address => address) private _delegates;

    constructor(uint256 initialSupply) ERC20("Szs", "SZS") {
        _mint(msg.sender, initialSupply);
    }

    function _delegate(address delegator, address delegatee) internal {
        _delegates[delegator] = delegatee;
    }

    function delegates(address account) public view  returns (address) {
        return _delegates[account];
    }

    function delegate(address delegatee) external {
        _delegate(msg.sender, delegatee);
    }

    function removeDelegate() external {
        _delegate(msg.sender,address(0));
    }
}
