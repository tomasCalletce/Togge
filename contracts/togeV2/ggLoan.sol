// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./depoManager.sol";
// import "./liquidationManager.sol";
// import "./paymentManager.sol";
// import "./withdrawManager.sol";


import "./data.sol";


//depoManager


contract ggLoan {

    Data dt;

    constructor(
        uint256 _poolSupplyMax,
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _loanAdmin
    ) {
        dt.poolSupplyMax = _poolSupplyMax;
        dt.numberBorrowerTokens = _numberBorrowerTokens;
        dt.reserveFactorMantissa = _reserveFactorMantissa;
        dt.borrower = _borrower;
        dt.borrowerToken = _borrowerToken;
        dt.loanAdmin = _loanAdmin;
    }

    modifier isBorrower() {
        require(msg.sender == dt.borrower,"TOGGE: prohibited");
        _;
    }

    // function depositTokens(uint _value) external isBorrower {
    //     depositManager.depositTokens(_value, Data.numberBorrowerTokens, Data.borrowerToken, Data.borrower, address(this));
    //     Data.startOfRaise = block.timestamp;
    //     Data.endOfRaise = Data.startOfRaise + 24 seconds;
    //     Data.endBorrowerAcceptWindow = Data.endOfRaise + 10 seconds;
    // }

    // //     // @LP -- supply eth to main vault
    // // function LP_deposit() external payable {

    // // }



    



}


