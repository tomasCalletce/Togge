//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DutchAuction {
    uint256 private constant DURATION = 1 days;
    uint256 startingPrice;
    address public admin;
    uint256 public immutable startAt;
    uint256 public immutable expiresAt;
    uint256 public immutable discountRate;

    constructor(
        uint256 _startingPrice,
        address _admin,
        uint256 _discountRate
    ) {
        startingPrice = _startingPrice;
        admin = _admin;
        discountRate = _discountRate;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        require(
            _startingPrice >= _discountRate * DURATION,
            "TOGGE:constructor greaterthanstartig"
        );
    }

    function getPrice() public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - startAt;
        uint256 discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function _grantPower(address Loan) internal pure {
        abi.encodeWithSignature("delegate(address)", Loan);
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "TOGGE:buy()->auction Expired");
        uint256 price = getPrice();
        if (msg.value < price && msg.value > 0) {
            payable(msg.sender).transfer(msg.value);
        }
        require(msg.value >= price, "ETH < price");
        _grantPower(msg.sender);
        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(payable(admin));
    }
}
