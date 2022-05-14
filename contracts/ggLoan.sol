// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./libraries/DepoManager.sol";
import "./libraries/WithdrawManager.sol";
import "./libraries/PaymentManager.sol";
import "./libraries/LiquidationManager.sol";
import "./tokens/DaoToken.sol";
import "./DutchAuction.sol";
import "./Data.sol";
import "hardhat/console.sol";

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
        dt.auctionDuration = 2 minutes; // 24 hours
        dt.duracionCiclo = 2 minutes; // 1 week
        dt.numCiclos = 2;
        dt.auctionStart = 0;
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
        isBorrower
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

    function makePayment() external payable {
        PaymentManager.makePayment(dt);
    }

    function liquidate() external {
        uint256 actualCycle = (block.timestamp - dt.endBorrowerAcceptWindow) /
            dt.duracionCiclo;
        require(
            dt.previousCycle != actualCycle,
            "TOGGE::liquidate() | still in previous cycle"
        );
        require(
            LiquidationManager.liquidate(dt),
            "TOGGE::liquidate() | DAO HAS PAYED"
        );

        dt.previousCycle =
            (dt.auctionStart + dt.auctionDuration) /
            dt.duracionCiclo;
        dt.auctionStart = block.timestamp;
        DaoToken(dt.borrowerToken).removeDelegate();
    }

    function buy() external payable {
        require(dt.auctionStart != 0, "TOGGE::buy() | AuctionNotStarted");
        DutchAuction.buy(dt);
        dt.auctionStart = 0;
    }

    function getPrice() external view returns (uint256) {
        require(dt.auctionStart != 0, "TOGGE::buy() | AuctionNotStarted");

        uint256 r = DutchAuction.getPrice(dt);
        console.log(r);
        return r;
    }

    function getLPAddress() external view returns (address) {
        return address(dt.LPnfts);
    }

    function getReserveFactorMantissa() external view returns (uint256) {
        return dt.reserveFactorMantissa;
    }

    function getNftCounter() external view returns (uint256) {
        return dt.nftCounter;
    }

    function getInteresTotal() external view returns (uint256) {
        return dt.interesTotal;
    }

    function getEthSupplied() external view returns (uint256) {
        return dt.ethSupplied;
    }

    function getUltimoPago() external view returns (uint256) {
        return dt.ultimoPago;
    }

    function getDeudaActual() external view returns (uint256) {
        return dt.deudaActual;
    }

    function getDeudaTotal() external view returns (uint256) {
        return dt.deudaTotal;
    }
}
