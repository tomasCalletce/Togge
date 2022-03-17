// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Loan.sol";


contract LoanMaker {

    event LoanCreated(uint _id,address _loan);

    address public admin;
    address[] public loans;

    constructor(){
        admin = msg.sender;

    }

    modifier isadmin(){
        require(msg.sender == admin,"TOGGE: NOT_ADMIN");
        _;
    }


    function createLoan (
        uint _interes,
        uint _total,
        uint _corte,
        uint _nTokens,
        address _token,
        address _dao,
        address _admin) external isadmin {
            uint _id = loans.length;

            Loan  _loan = new Loan(
                _interes,
                _total,
                _corte,
                _nTokens,
                 _token,
                 _dao,
                 _admin
            );

            loans.push(address(_loan));
            emit LoanCreated(_id,address(_loan));
    }

    function getLoans() external view returns (address[] memory){
        return loans;
    } 


}