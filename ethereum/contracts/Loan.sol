// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Loan{

    event left(uint _total,uint _amount);
    // Change everything to English 


    uint interes;
    uint total;
    uint corte;
    uint nTokens;
    address token;
    address dao;
    address admin;
    uint fechaMAX;
    uint amount;
    mapping(address=>uint) public deposits;


    constructor(
        uint _interes,
        uint _total,
        uint _corte,
        uint _nTokens,
        address _token,
        address _dao,
        address _admin) payable{
        interes = _interes;
     total=_total;
     corte=_corte;
     nTokens=_nTokens ;
     token=_token;
     dao = _dao; 
     admin=_admin ;
     amount = 0;
     fechaMAX = block.timestamp + 24 hours;
     /* As soon as the contract is created the 24 hour time window to deposit 
     liquidity is open. If the intended amount for the loan is not achieved 
     then the LPs are free to withdraw their liquidity and the DAO can withdraw his tokens. 
     On the other hand, if the amount is indeed achieved then the loan process commences and the LPs will 
     only be able to make withdraws once the loan is paid for. 
    */
    }


    modifier isborrower(){
        require(msg.sender == dao);
        _;
    }
    
    function deposit_LP()external payable{
        require(block.timestamp<=fechaMAX,"Time past");
        require(amount+msg.value<total,"total surpast");
        emit left(total,amount);

        deposits[msg.sender] += msg.value;
        amount +=msg.value;
        // The LPs can only make deposits for 24 hours after the loan contract was created.
    }
    function withdrawTokensDAO()external isborrower{
        // If the desired loan amount is not achieved then the DAO can withdraw his tokens
    }

    function createLPtoken() external {
        /*Any LP can call the create LP token function. This function will create an RC20  
        token that represents your stake in the pool.
        */
    }

    function withdrawLPtoken() external {
        /*
        Once an LP token is created then LPs can call the function to receive a function that 
        represents their stake in the loan. Interest will be paid out by the appreciation of this token. 
        Because the DAO will pay his interest directly to the loan pool the percentage on the value that your 
        token represents will be higher 
        in eth terns ounce the loan is completely paid with interest.
        */
    }

    function withdrawETHdao() external isborrower{
        /* is the intended amount is successfully raised from LPs in the 24-hour 
        window after the creation of the loan contract then DAO may withdraw his loan in ether.
        */
    }


    function withdrawFailedDeposits() external {
        require(deposits[msg.sender]!=0,"noDeposits");
        require(amount<total,"total surpast");
        require(block.timestamp>fechaMAX,"TimeNotPast");
        uint dep = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool sent, ) =  payable(msg.sender).call{value: dep}("");
        require(sent, "Failed to send Ether");
        // If the desired loan amount is not achieved then the LP can withdraw the ether he deposited 
    }
}