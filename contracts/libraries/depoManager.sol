// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../Data.sol";
import "../tokens/GGETH.sol";

library DepoManager {
    //@Borrower -- deposit governance token
    function depositTokens(uint256 _value, Data storage dt) external {
        require(_value == dt.numberBorrowerTokens, "TOGGE: NOT_APPROVED_VALUE");
        bool success = ERC20(dt.borrowerToken).transferFrom(
            dt.borrower,
            address(this),
            _value
        );
        require(success, "TOGGE: TRANSFER_FAILED");
        dt.startOfRaise = block.timestamp;
        dt.endOfRaise = dt.startOfRaise + 60 seconds;
        dt.endBorrowerAcceptWindow = dt.endOfRaise + 60 seconds;
    }

    // @LP -- supply eth to main vault
    function LP_deposit(Data storage dt) external {
        // require(msg.sender != dt.borrower, "TOGGE: INVALID_BORROWER");
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > dt.startOfRaise && _currentTime < dt.endOfRaise,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );
        require(dt.deposits[msg.sender] == 0, "already deposited");
        dt.deposits[msg.sender] = msg.value;
        // if (dt.accum.length != 0) {
        //     uint256 temp = dt.accum[dt.currentIndex++] + msg.value;
        //     dt.accum.push(temp);
        // } else {
        //     dt.accum.push(msg.value);
        // }
        // dt.indexing[msg.sender] = dt.currentIndex;
        dt.ethSupplied += msg.value;
    }

    //   uint256 poolSupplyMax;
    // uint256 numberBorrowerTokens;
    // uint256 reserveFactorMantissa;
    // uint256 endOfRaise;
    // uint256 startOfRaise;
    // uint256 endBorrowerAcceptWindow;
    // address borrower;
    // address borrowerToken;
    // address loanAdmin;
    // mapping(address => uint256) indexing;
    // mapping(address => uint256) deposits;
    // uint256[] accum;
}
