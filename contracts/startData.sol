// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

struct StartData {
    uint256 poolSupplyMax;
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