// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./ggeth.sol";


contract LoanMaker {

    address admin;
    togLoan[] public allLoans;

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
        address _admin) external isadmin returns (uint){
            uint _id = allLoans.length;

            ggEther  _loan = new togLoan(
                _interes,
                _total,
                _corte,
                _nTokens,
                 _token,
                 _dao,
                 _admin
            );

            allLoans.push(_loan);
            return _id;
        } 

}




