// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "../Data.sol";

library PaymentManager {
    function makePayment(Data storage dt) external {
        require(dt.deudaActual >= msg.value); //ya pago mas de lo que debia
        dt.deudaActual -= msg.value;
        dt.ultimoPago = block.timestamp;
    }
}
