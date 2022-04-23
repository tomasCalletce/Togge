// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./ggETH.sol";
struct Data {
    uint256 poolSupplyMax;
    uint256 numberBorrowerTokens;
    uint256 reserveFactorMantissa;
    uint256 endOfRaise;
    uint256 startOfRaise;
    uint256 currentIndex;
    uint256 endBorrowerAcceptWindow;
    uint256 nftCounter;
    uint256 valorDAORecibido;
    uint256 valorRetiroLPs;
    uint256 interesTotal;
    uint256 ethSupplied;
    //interest rate
    uint256 goalAmount;
    uint256 multiplier;
    //variables payment
    uint256 ultimoPago;
    uint256 deudaActual;
    uint256 duracionCiclo;
    uint256 numCiclos;
    uint256 deudaTotal;
    //<----------------------->
    address borrower;
    address borrowerToken;
    address loanAdmin;
    bool loanAccepted;
    mapping(address => uint256) indexing;
    mapping(address => uint256) deposits;
    mapping(address => bool) nftClaimed;
    uint256[] accum;
    ggETHV2 LPnfts;
}
