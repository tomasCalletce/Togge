// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./DepositManager.sol";
import "./liquidationManager.sol";
import "./paymentManager.sol";
import "./withdrawManager.sol";




contract ggLoan {

    uint public poolSupplyMax;
    uint public numberBorrowerTokens;
    uint public reserveFactorMantissa;

    // time limit supply ETH to vault
    uint public endOfRaise;

    // time start supply ETH to vault
    uint public startOfRaise;

    // end time for DAO to accept loan
    uint public endBorrowerAcceptWindow;

    address public borrower;
    address public borrowerToken;
    address public loanAdmin;

    DepositManager depositManager;

    constructor(
        uint256 _poolSupplyMax,
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin,
        address _depositManager
    ) {
        poolSupplyMax = _poolSupplyMax;
        numberBorrowerTokens = _numberBorrowerTokens;
        reserveFactorMantissa = _reserveFactorMantissa;
        borrower = _borrower;
        borrowerToken = _borrowerToken;
        loanAdmin = _loanAdmin;
        depositManager = DepositManager(_depositManager);
    }

    modifier isBorrower() {
        require(msg.sender == borrower,"TOGGE: prohibited");
        _;
    }

    function depositTokens(uint _value) external isBorrower {
        depositManager.depositTokens(_value, numberBorrowerTokens, borrowerToken, borrower, address(this));
        startOfRaise = block.timestamp;
        endOfRaise = startOfRaise + 24 seconds;
        endBorrowerAcceptWindow = endOfRaise + 10 seconds;
    }

}


