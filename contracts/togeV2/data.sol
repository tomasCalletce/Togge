// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


struct Data {

    uint poolSupplyMax;
    uint numberBorrowerTokens;
    uint reserveFactorMantissa;
    uint endOfRaise;
    uint startOfRaise;
    uint endBorrowerAcceptWindow;

    address borrower;
    address borrowerToken;
    address loanAdmin;

    mapping(address => uint) indexing;
    mapping(address => uint) deposits;

    uint[] accum;

}