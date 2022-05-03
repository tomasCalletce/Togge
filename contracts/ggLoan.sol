// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./libraries/depoManager.sol";
import "./libraries/withdrawManager.sol";
import "./libraries/paymentManager.sol";
import "./data.sol";
import "./startData.sol";



contract ggLoan {

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
        depoManager.depositTokens(
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
        depoManager.LP_deposit(dt);
    }

    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol) external {
        withdrawManager.acceptLoanWithdrawLoan(_name, _symbol, dt);
    }

    function withdrawFailedDeposits() external {
        withdrawManager.withdrawFailedDeposits(dt);
    }

    function withdrawLPtoken() external {
        withdrawManager.withdrawLPtoken(dt);
    }

    function withdraw() external {
        withdrawManager.withdraw(dt);
    }

    function makePayment() external {
        paymentManager.makePayment(dt);
    }

    // function liquidate() external{
    //     payment
    // }
}
