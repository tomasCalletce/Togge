// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../data.sol";
import "../tokens/ggETH.sol";

library depoManager {
    //@Borrower -- deposit governance token
    function depositTokens(
        uint256 _value,
        uint256 _numberBorrowerTokens,
        uint256 _startOfRaise,
        uint256 _endOfRaise,
        uint256 _endBorrowerAcceptWindow,
        address _borrowerToken,
        address _borrower
    ) external {
        require(_value == _numberBorrowerTokens, "TOGGE: NOT_APPROVED_VALUE");
        bool success = ERC20(_borrowerToken).transferFrom(
            _borrower,
            address(this),
            _value
        );
        require(success, "TOGGE: TRANSFER_FAILED");
        _startOfRaise = block.timestamp;
        _endOfRaise = _startOfRaise + 24 seconds;
        _endBorrowerAcceptWindow = _endOfRaise + 10 seconds;
    }

    // @LP -- supply eth to main vault
    function LP_deposit(Data storage dt) external {
        require(msg.sender != dt.borrower, "TOGGE: INVALID_BORROWER");
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > dt.startOfRaise && _currentTime < dt.endOfRaise,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );
        require(dt.deposits[msg.sender] == 0, "already deposited");
        dt.deposits[msg.sender] = msg.value;
        if (dt.accum.length != 0) {
            uint256 temp = dt.accum[dt.currentIndex++] + msg.value;
            dt.accum.push(temp);
        } else {
            dt.accum.push(msg.value);
        }
        dt.indexing[msg.sender] = dt.currentIndex;
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
