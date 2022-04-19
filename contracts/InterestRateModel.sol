// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract InterestRateModel {
    function getBorrowRate(
        uint256 goalAmount,
        uint256 achievedAmount,
        uint256 _multiplier
    ) external pure returns (uint256) {
        require(achievedAmount > 0, "TOGGE: MATH_ERR");
        require(goalAmount > 0, "TOGGE: WRONG_GOAL_AMOUNT");

        return (_multiplier * (goalAmount / achievedAmount));
    }
}
