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

    function makeLoan(
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        uint256 _goalAmount,
        uint256 _multiplier,
        uint256 _discountRate,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin
    ) external isadmin returns (uint256) {
        uint256 _id = loans.length;
        GGLoan _loan = new GGLoan(
            _numberBorrowerTokens,
            _reserveFactorMantissa,
            _goalAmount,
            _multiplier,
            _discountRate,
            _borrower,
            _borrowerToken,
            _loanAdmin
        );
        loans.push(_loan);
        return _id;
    }
}

// remixd -s ./hardhat.config.js --remix-ide https://remix.ethereum.org/65520