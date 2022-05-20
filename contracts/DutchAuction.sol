//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Data.sol";

import "./tokens/DaoToken.sol";

library DutchAuction {
    function setPrice(Data storage dt) public {
        if (dt.auctionStart == 0) {
            dt.price = dt.deudaActual * 2;
        } else {
            uint256 timeElapsed = block.timestamp - dt.auctionStart;
            uint256 discount = dt.discountRate * timeElapsed;
            require(
                (dt.deudaActual * 2) > discount,
                "DutchAuction::setPrice | menor a 0"
            );
            dt.price = (dt.deudaActual * 2) - discount;
        }
    }

    function _grantPower(address _delegatee, Data storage dt) internal {
        DaoToken(dt.borrowerToken).delegate(_delegatee);
    }

    function buy(Data storage dt) external {
        require(
            block.timestamp < dt.auctionStart + dt.auctionDuration,
            "TOGGE:buy()->auction Expired"
        );
        if (msg.value < dt.price) {
            payable(msg.sender).transfer(msg.value);
        }
        require(msg.value >= dt.price, "ETH < price");
        _grantPower(msg.sender, dt);
        uint256 refund = msg.value - dt.price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
    }
}
