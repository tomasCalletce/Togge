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

    uint interest;
    uint total;
    uint cut;
    uint nTokens;
    uint timeLimit;
    uint amount;

    address token;
    address dao;
    address admin;

    bool withdrawedTokenDAO;
    bool paid;
    ggETH LPtoken;
   
    mapping(address=>uint) public deposits;

    constructor(
        uint _interest,
        uint _total,
        uint _cut,
        uint _nTokens,
        address _token,
        address _dao,
        address _admin) payable{
        interest = _interest;
     total=_total;
     cut=_cut;
     nTokens=_nTokens ;
     token=_token;
     dao = _dao; 
     admin=_admin ;
     amount = 0;
     withdrawed = false;
     paid = true;

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
    //DAO functions
    function withdrawETHdao() external isborrower{
        /* 
        Is the intended amount is successfully raised from LPs in the 24-hour 
        window after the creation of the loan contract then DAO may withdraw his loan in ether.
        */
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");
        require(!withdrawed);

        withdrawed = !withdrawed;
        total = 0;
        uint _amount = amount;

        (bool sent, ) =  payable(msg.sender).call{value: _amount}("");
        require(sent, "TOGGE: FAILED_SEND");
        emit ethWithdraw(amount);
    }

    function depositTokens_startLPdeposits(uint _value) external isborrower{
        //The 24 h time limit is set, as the DAO deposits its tokens as collateral
        uint _nTokens = nTokens;
        address _token = token;
        address _dao = dao;

        require(_value == _nTokens,"TOGGE: NOT_TOKEN");
        
        bool success = IERC20(_token).transferFrom(_dao,address(this),_value);
        require(success,"TOGGE: TRANSFER_FAILED");
        emit tokenDeposited(_value,address(this));

        timeLimit = block.timestamp + 24 hours;
        emit LPdepositsActive(block.timestamp,timeLimit);
    }

    function payLoan()external payable{
        //Dao pays the owed money + interest and gets tokens back
        uint meses = (block.timestamp - timeLimit)/(60*60*24*30);
        require(withdrawed);

        total += msg.value;

        require(total >= (amount + amount*interest*meses),"TOGGE: UNDER_PAY");
        paid = true;
    }

    function withdrawTokensDAO()external isborrower{
        // After paying the loan, the DAO can get back the Tokens used as collateral
        require(paid,"TOGGE: OVER_MAX"); //aqui hay un problema
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        

        bool _respo = IERC20(token).transfer(dao,nTokens);
        require(_respo, "TOGGE: FAILED_SEND");
        emit tokenWithdraw(dao,nTokens);

    }
    //LP functions
     function deposit_LP()external payable{
        // The LPs can only make deposits for 24 hours after the loan contract was created.
        require(block.timestamp<=timeLimit,"TOGGE: TIME_PAST");
        require(amount+msg.value<total,"TOGGE: OVER_MAX");
        emit left(total,amount);

        deposits[msg.sender] += msg.value;
        amount += msg.value;
        
    }

    function createLPtoken(string memory _name, string memory _symbol) external isadmin{ 
        //We create the LP token that represents the share of the pool the LP owns
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken = new ggETH(_name,_symbol); 
        emit LPtokencreated(address(LPtoken));
    }

    function withdrawLPtoken() external {
        /*
        Once an LP token is created then LPs can call the function to receive a function that 
        represents their stake in the loan. interest will be paid out by the appreciation of this token. 
        Because the DAO will pay his interest directly to the loan pool the percentage on the value that your 
        token represents will be higher 
        in eth terns ounce the loan is completely paid with interest.
        */
        require(deposits[msg.sender]!= 0,"TOGGE: NO_VALUE");
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken.mint(msg.sender,deposits[msg.sender]);
    }

    function withdrawFailedDeposits() external {
        //If the desired loan amount is not achieved then the LP can withdraw the ether he deposited 

        require(deposits[msg.sender]!=0,"TOGGE: NO_VALUE");
        require(amount<total,"TOGGE: OVER_MAX");
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");

        uint _deposit = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool sent, ) =  payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
        
    }
}