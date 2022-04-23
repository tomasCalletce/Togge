// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ggLoan.sol";

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

    function makeLoan(
        uint256 _poolSupplyMax,
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        uint256 _duracionCiclo,
        uint256 _numCiclos,
        uint256 _goalAmount,
        uint256 _multiplier,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin
    ) external isadmin returns (uint256) {
        uint256 _id = loans.length;

        ggLoan _loan = new ggLoan(
            _poolSupplyMax,
            _numberBorrowerTokens,
            _reserveFactorMantissa,
            _duracionCiclo,
            _numCiclos,
            _goalAmount,
            _multiplier,
            _borrower,
            _borrowerToken,
            _loanAdmin
        );

        loans.push(_loan);
        return _id;
    }
}
