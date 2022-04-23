// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./depoManager.sol";
import "./withdrawManager.sol";
import "./paymentManager.sol";
// import "./liquidationManager.sol";
// import "./paymentManager.sol";
// import "./withdrawManager.sol";

import "./data.sol";

//depoManager

contract ggLoan {
    Data dt;

    constructor(
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
    ) {
        dt.poolSupplyMax = _poolSupplyMax;
        dt.numberBorrowerTokens = _numberBorrowerTokens;
        dt.reserveFactorMantissa = _reserveFactorMantissa;
        dt.borrower = _borrower;
        dt.borrowerToken = _borrowerToken;
        dt.loanAdmin = _loanAdmin;
        dt.duracionCiclo = _duracionCiclo;
        dt.numCiclos = _numCiclos;
        dt.goalAmount = _goalAmount;
        dt.multiplier = _multiplier;
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

    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol)
        external
    {
        withdrawManager.acceptLoanWithdrawLoan(_name, _symbol, dt);
    }

    function withdrawFailedDeposits() external {
        withdrawManager.withdrawFailedDeposits(dt);
    }

    function withdrawLPtoken() external {
        withdrawManager.withdrawLPtoken(dt);
    }

    // @LP - withdraw deposit + interest
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
