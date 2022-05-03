// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./libraries/DepoManager.sol";
import "./libraries/WithdrawManager.sol";
import "./libraries/PaymentManager.sol";
import "./Data.sol";

struct StartData {
    uint256 numberBorrowerTokens;
    uint256 reserveFactorMantissa;
    uint256 duracionCiclo;
    uint256 numCiclos;
    uint256 goalAmount;
    uint256 multiplier;
    uint256 discountRate;
    uint256 auctionDuration;
    address borrower;
    address borrowerToken;
    address loanAdmin;
}


contract GGLoan {

    Data dt;

    constructor(StartData memory st) {
        dt.numberBorrowerTokens = st.numberBorrowerTokens;
        dt.reserveFactorMantissa = st.reserveFactorMantissa;
        dt.borrower = st.borrower;
        dt.borrowerToken = st.borrowerToken;
        dt.loanAdmin = st.loanAdmin;
        dt.duracionCiclo = st.duracionCiclo;
        dt.numCiclos = st.numCiclos;
        dt.goalAmount = st.goalAmount;
        dt.multiplier = st.multiplier;
        dt.discountRate = st.discountRate;
        dt.auctionDuration = st.auctionDuration;
    }

    modifier isBorrower() {
        require(msg.sender == dt.borrower, "TOGGE: prohibited");
        _;
    }

    function depositTokens(uint256 _value) external isBorrower {
        DepoManager.depositTokens(
            _value,
            dt.numberBorrowerTokens,
            dt.startOfRaise,
            dt.endOfRaise,
            dt.endBorrowerAcceptWindow,
            dt.borrowerToken,
            dt.borrower
        );
    }

    function LP_deposit() external payable {
        DepoManager.LP_deposit(dt);
    }

    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol) external {
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
