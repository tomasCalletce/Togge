// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ggLoan.sol";
import "./startData.sol";

contract ggLoanMaker {
    
    address public admin;
    ggLoan[] public loans;

    constructor() {
        admin = msg.sender;
    }

    modifier isadmin() {
        require(msg.sender == admin, "TOGGE: NOT_ADMIN");
        _;
    }

    function makeLoan(StartData memory sd) external isadmin returns (uint256) {
        uint256 _id = loans.length;
        ggLoan _loan = new ggLoan(sd);
        loans.push(_loan);
        return _id;
    }
}
