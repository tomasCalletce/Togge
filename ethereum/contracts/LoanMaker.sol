// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./Loan.sol";

contract LoanMaker {

    address admin;
    Loan[] public loans;

    constructor(){
        admin = msg.sender;

    }

    modifier isadmin(){
        require(msg.sender == admin,"TOGGE: NOT_ADMIN");
        _;
    }

    function createLoan(
        uint _interes,
        uint _total,
        uint _corte,
        uint _nTokens,
        address _token,
        address _dao,
        address _admin) external isadmin {

            Loan  _loan = new Loan(
                _interes,
                _total,
                _corte,
                _nTokens,
                 _token,
                 _dao,
                 _admin
            );

            loans.push(_loan);
        } 

 
}