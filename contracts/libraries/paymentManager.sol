// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "../Data.sol";

library PaymentManager {
    function makePayment(Data storage dt) external {
        dt.deudaActual -= msg.value;
    }
}
