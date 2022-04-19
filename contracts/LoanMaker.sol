// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ggeth.sol";
import "./togLoan.sol";

contract LoanMaker {
    address admin;
    togLoan[] public allLoans;

    constructor() {
        admin = msg.sender;
    }

    modifier isadmin() {
        require(msg.sender == admin, "TOGGE: NOT_ADMIN");
        _;
    }

    function createLoan(
        uint _poolSupplyMax,
        uint _numberBorrowerTokens,
        uint _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _admin
    ) external isadmin returns (uint) {
        uint _id = allLoans.length;

        togLoan _loan = new togLoan(
            _poolSupplyMax,
            _numberBorrowerTokens,
            _reserveFactorMantissa,
            _borrower,
            _borrowerToken,
            _admin
        );

        allLoans.push(_loan);
        return _id;
    }
}
