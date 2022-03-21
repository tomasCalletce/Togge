// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;



contract InterestRateModel {

    function getBorrowRate(uint goalAmount, uint achievedAmount,uint _multiplier) external pure returns (uint) {
        require(achievedAmount > 0,"TOGGE: MATH_ERR");
        require(goalAmount > 0,"TOGGE: WRONG_GOAL_AMOUNT");
        
        return (_multiplier*(goalAmount/achievedAmount));
    }

}