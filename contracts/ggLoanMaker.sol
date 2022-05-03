// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./GGLoan.sol";


contract GGLoanMaker {
    
    address public admin;
    GGLoan[] public loans;

    constructor() {
        admin = msg.sender;
    }

    modifier isadmin() {
        require(msg.sender == admin, "TOGGE: NOT_ADMIN");
        _;
    }

    function makeLoan(StartData memory sd) external isadmin returns (uint256) {
        uint256 _id = loans.length;
        GGLoan _loan = new GGLoan(sd);
        loans.push(_loan);
        return _id;
    }
}
