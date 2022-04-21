// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ggLoan.sol";

contract ggLoanMaker{

    address public admin;
    ggLoan[] public loans;
    
    constructor() {
        admin = msg.sender;
    }

    modifier isadmin() {
        require(msg.sender == admin, "TOGGE: NOT_ADMIN");
        _;
    }

    function makeLoan(
        uint _poolSupplyMax,
        uint _numberBorrowerTokens,
        uint _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin,
        address _depositManager
    ) external isadmin returns (uint) {
        uint _id = loans.length;

        ggLoan _loan = new ggLoan(
            _poolSupplyMax,
            _numberBorrowerTokens,
            _reserveFactorMantissa,
            _borrower,
            _borrowerToken,
            _loanAdmin,
            _depositManager
        );

        loans.push(_loan);
        return _id;
    }

    
}




