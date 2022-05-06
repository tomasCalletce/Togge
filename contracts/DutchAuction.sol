//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Data.sol";

library DutchAuction {
    function getPrice(Data storage dt) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - dt.auctionStart;
        uint256 discount = dt.discountRate * timeElapsed;
        return (dt.deudaActual * 2) - discount;
    }

    // function _grantPower(address _delegatee) internal pure {
    //     // abi.encodeWithSignature("delegate(address)", _delegatee);
    // }
    function buy(Data storage dt) external {
        require(
            block.timestamp < dt.auctionStart + dt.auctionDuration,
            "TOGGE:buy()->auction Expired"
        );
        uint256 price = getPrice(dt);
        if (msg.value < price) {
            payable(msg.sender).transfer(msg.value);
        }
        require(msg.value >= price, "ETH < price");
        //_grantPower(msg.sender);
        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }
}
