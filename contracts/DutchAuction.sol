//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./data.sol";

library DutchAuction {
    //startingPrice = _startingPrice;
    // discountRate = _discountRate;
    // startAt = block.timestamp;
    // expiresAt = block.timestamp + DURATION;
    // constructor(
    //     uint256 _startingPrice,
    //     address _admin,
    //     uint256 _discountRate
    // ) {
    //     require(
    //         _startingPrice >= _discountRate * DURATION,
    //         "TOGGE:constructor greaterthanstartig"
    //     );
    // }
    // function getPrice(Data dt) public view returns (uint256) {
    //     uint256 timeElapsed = block.timestamp - startAt;
    //     uint256 discount = dt.discountRate * dt.timeElapsed;
    //     return dt.startingPrice - dt.discount;
    // }
    // function _grantPower(address _delegatee) internal pure {
    //     // abi.encodeWithSignature("delegate(address)", _delegatee);
    // }
    // function buy() external payable {
    //     require(block.timestamp < expiresAt, "TOGGE:buy()->auction Expired");
    //     uint256 price = getPrice();
    //     if (msg.value < price && msg.value > 0) {
    //         payable(msg.sender).transfer(msg.value);
    //     }
    //     require(msg.value >= price, "ETH < price");
    //     _grantPower(msg.sender);
    //     uint256 refund = msg.value - price;
    //     if (refund > 0) {
    //         payable(msg.sender).transfer(refund);
    //     }
    //     selfdestruct(payable(admin));
    // }
}
