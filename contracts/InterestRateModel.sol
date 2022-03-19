// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;



contract InterestRateModel {


    function getBorrowRate(uint _multiplier,uint _baseRate,uint _utilizationRate) public pure returns (uint){
        return (_multiplier*_utilizationRate) + _baseRate;
    }
 
    function getSupplyRate(uint _reserveFactor,uint _multiplier,uint _baseRate,uint _utilizationRate) external pure returns (uint) {
        uint _borrowRate = getBorrowRate(_multiplier,_baseRate,_utilizationRate);
        return _borrowRate*_utilizationRate*(1-_reserveFactor);
    }

    function utilizationRate(uint goalAmount, uint achievedAmount) external pure returns (uint) {
        require(achievedAmount != 0,"InterestRateModel: NO_DIV_BY_ZERO");
        
        return  achievedAmount/goalAmount;
    }

}