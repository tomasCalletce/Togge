// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract withdrawManager {

    address ggLoan;

    constructor(){
        ggLoan = msg.sender;
    }

    modifier isggLoan(){
        require(msg.sender == ggLoan,"withdrawManager: NOT_GGLOAN");
        _;
    }
    
}
