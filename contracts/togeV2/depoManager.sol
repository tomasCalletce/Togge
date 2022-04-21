
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library depoManager {


     //@Borrower -- deposit governance token
    function depositTokens (
        uint _value,
        uint _numberBorrowerTokens,
        uint _startOfRaise,
        uint _endOfRaise,
        uint _endBorrowerAcceptWindow,
        address _borrowerToken,
        address _borrower
        )
        external {
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




}
