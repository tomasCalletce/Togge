
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ggeth.sol";

contract Loan{

    event left(uint _total,uint _value);
    event tokenDeposited(uint _amount, address recipient);
    event LPdepositsActive(uint _start,uint _end);
    event ethWithdraw(uint _value);
    event tokenWithdraw(address _to,uint _value);
    event LPtokencreated(address _token);

    // Change everything to English 

    uint interes;
    uint total;
    uint corte;
    uint nTokens;
    uint fechaMAX;
    uint amount;

    address token;
    address dao;
    address admin;
    ggETH LPtoken;
   
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

     /* 
     As soon as the contract is created the 24 hour time window to deposit 
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

    modifier isadmin(){
        require(msg.sender == admin);
        _;
    }


    function depositTokens_startLPdeposits(uint _value) external isborrower{
        uint _nTokens = nTokens;
        address _token = token;
        address _dao = dao;

        require(_value == _nTokens,"TOGGE: NOT_TOKEN");
        
        bool success = IERC20(_token).transferFrom(_dao,address(this),_value);
        require(success,"TOGGE: TRANSFER_FAILED");
        emit tokenDeposited(_value,address(this));

        fechaMAX = block.timestamp + 24 hours;
        emit LPdepositsActive(block.timestamp,fechaMAX);
    }


    
    function deposit_LP()external payable{
        // The LPs can only make deposits for 24 hours after the loan contract was created.
        require(block.timestamp<=fechaMAX,"TOGGE: TIME_PAST");
        require(amount+msg.value<total,"TOGGE: OVER_MAX");
        emit left(total,amount);

        deposits[msg.sender] += msg.value;
        amount += msg.value;
        
    }


    function withdrawTokensDAO()external isborrower{
        require(amount<total,"TOGGE: OVER_MAX");
        require(block.timestamp>fechaMAX,"TOGGE: NOT_END");
        

        bool _respo = IERC20(token).transfer(dao,nTokens);
        require(_respo, "TOGGE: FAILED_SEND");
        emit tokenWithdraw(dao,nTokens);

    }

    function createLPtoken(string memory _name, string memory _symbol) external isadmin{
        require(block.timestamp>fechaMAX,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken = new ggETH(_name,_symbol); 
        emit LPtokencreated(address(LPtoken));
    }

    function withdrawLPtoken() external {
        /*
        Once an LP token is created then LPs can call the function to receive a function that 
        represents their stake in the loan. Interest will be paid out by the appreciation of this token. 
        Because the DAO will pay his interest directly to the loan pool the percentage on the value that your 
        token represents will be higher 
        in eth terns ounce the loan is completely paid with interest.
        */
        require(deposits[msg.sender]!= 0,"TOGGE: NO_VALUE");
        require(block.timestamp>fechaMAX,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken.mint(msg.sender,deposits[msg.sender]);
    }

    function withdrawETHdao() external isborrower{
        /* 
        Is the intended amount is successfully raised from LPs in the 24-hour 
        window after the creation of the loan contract then DAO may withdraw his loan in ether.
        */
        require(block.timestamp>fechaMAX,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        uint _amount = amount;
        amount = 0;

        (bool sent, ) =  payable(msg.sender).call{value: _amount}("");
        require(sent, "TOGGE: FAILED_SEND");
        emit ethWithdraw(amount);
    }


    function withdrawFailedDeposits() external {
        //If the desired loan amount is not achieved then the LP can withdraw the ether he deposited 

        require(deposits[msg.sender]!=0,"TOGGE: NO_VALUE");
        require(amount<total,"TOGGE: OVER_MAX");
        require(block.timestamp>fechaMAX,"TOGGE: NOT_END");

        uint _deposit = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool sent, ) =  payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
        
    }
}