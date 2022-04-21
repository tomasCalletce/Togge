// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

struct Data {
    uint256 poolSupplyMax;
    uint256 numberBorrowerTokens;
    uint256 reserveFactorMantissa;
    uint256 endOfRaise;
    uint256 startOfRaise;
    uint256 endBorrowerAcceptWindow;
    address borrower;
    address borrowerToken;
    address loanAdmin;
    mapping(address => uint256) indexing;
    mapping(address => uint256) deposits;
    uint256[] accum;
    uint256[] accums;
}
