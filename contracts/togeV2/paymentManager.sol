// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "./data.sol";

library paymentManager {
    function makePayment(Data storage dt) external {
        dt.deudaActual -= msg.value;
    }
}
