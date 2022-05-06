pragma solidity ^0.8.4;

library InterestRateModel {
    function getBorrowRate(
        uint256 _goalAmount,
        uint256 _achievedAmount,
        uint256 _multiplier
    ) internal pure returns (uint256) {
        require(_achievedAmount > 0, "TOGGE: MATH_ERR");
        require(_goalAmount > 0, "TOGGE: WRONG_GOAL_AMOUNT");

        return (_multiplier * (_goalAmount / _achievedAmount)) / 100;
    }
}
