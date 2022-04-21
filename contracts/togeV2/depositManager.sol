// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DepositManager {

    //@Borrower -- deposit governance token
    function depositTokens(uint _value,uint _numberBorrowerTokens,address _borrowerToken,address _borrower,address _lender) external {
        require(_value == _numberBorrowerTokens, "depositManager: NOT_APPROVED_VALUE");

        bool success = ERC20(_borrowerToken).transferFrom(
            _borrower,
            _lender,
            _value
        );
        require(success,"depositManager: NO_TRANSFER"); 
    }

}
