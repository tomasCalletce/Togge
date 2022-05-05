// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./libraries/DepoManager.sol";
import "./libraries/WithdrawManager.sol";
import "./libraries/PaymentManager.sol";
import "./Data.sol";

contract GGLoan {
    Data dt;

    constructor(
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        uint256 _goalAmount,
        uint256 _multiplier,
        uint256 _discountRate,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin
    ) {
        dt.numberBorrowerTokens = _numberBorrowerTokens;
        dt.reserveFactorMantissa = _reserveFactorMantissa;
        dt.borrower = _borrower;
        dt.borrowerToken = _borrowerToken;
        dt.loanAdmin = _loanAdmin;
        dt.goalAmount = _goalAmount;
        dt.multiplier = _multiplier;
        dt.discountRate = _discountRate;
        dt.auctionDuration = 86400; // 24 hours
        dt.duracionCiclo = 604800; // 1 week
        dt.numCiclos = 10;
    }

    modifier isBorrower() {
        require(msg.sender == dt.borrower, "TOGGE: prohibited");
        _;
    }

    function depositTokens(uint256 _value) external isBorrower {
        DepoManager.depositTokens(_value, dt);
    }

    function LP_deposit() external payable {
        DepoManager.LP_deposit(dt);
    }

    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol)
        external
    {
        WithdrawManager.acceptLoanWithdrawLoan(_name, _symbol, dt);
    }

    function withdrawFailedDeposits() external {
        WithdrawManager.withdrawFailedDeposits(dt);
    }

    function withdrawLPtoken() external {
        WithdrawManager.withdrawLPtoken(dt);
    }

    function withdraw() external {
        WithdrawManager.withdraw(dt);
    }

    function makePayment() external {
        PaymentManager.makePayment(dt);
    }

    // function liquidate() external{
    //     payment
    // }
}
