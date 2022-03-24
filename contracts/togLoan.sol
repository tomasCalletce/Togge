// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



import "./ggeth.sol";
import "./InterestRateModel.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract togLoanStorage {

}

contract togLoan {

    // open vault to investors
    event borrowerTokenDeposited(uint _amount);

    event supplyVaultNowOpen(uint _timeLimit);

    event ethWithdrawBorrower(uint _value);


    // $$$$ MUST CHANGE NAMES $$$$

    event Deposit(address,uint);

    event ArrayVal(uint);

    event Withdraw(address,uint);

    event balance(uint);

    // $$$$ MUST CHANGE NAMES $$$$



    struct Payment {
        
        // percent of total borrowed as decimal * 10^18
        uint percet;

        // state of payment
        bool complete;

        // max date for payment 
        uint maxDate;

        // pending val
        uint val;

    }


    // loan accepted 
    bool public loanAccepted;

    // Loan Maker / admin 
    address public immutable admin;

    // borrower governance token
    address public  borrowerToken;

    // borrower address
    address public  borrower;

    // promised number of borrower tokens
    uint public numberBorrowerTokens;
    
    // max supply eth 
    uint public poolSupplyMax;

    // time limit supply ETH to vault
    uint public endOfRaise;

    // time start supply ETH to vault
    uint public startOfRaise;

    // end time for DAO to accept loan 
    uint public endBorrowerAcceptWindow;

    // eth supplied 
    uint public ethSupplied;

    // index of current pending payment 
    uint public pendingPayIndex;

    // eth paid by borrower 
    uint public loanPaid;

    // eth loan with interest  
    uint public totalLoan;



    // $$$$ MUST CHANGE NAMES $$$$

    // amount paid 
    uint public valorDAORecibido = 0;

    // amount withdrawn
    uint public valorRetiroLPs = 0;

    // current lp index
    uint public currentIndex = 0;

    // 
    mapping(address=>uint) indexing;

    // deposit balance by LP 
    mapping(address=>uint) posiciones;

    // lp seniority manager
    uint[] public accum;

    // $$$$ MUST CHANGE NAMES $$$$




    // list of payment 
    Payment[] public payments;

    // LP nft contract 
    ERC721 public LPnfts;



    // caller is 
    modifier isBorrower(){
        require(msg.sender == borrower);
        _;
    }

    // caller is admin 
    modifier isadmin(){
        require(msg.sender == admin);
        _;
    }


    constructor(
        uint _poolSupplyMax,
        uint _numberBorrowerTokens,
        uint _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _admin,
        uint[] memory maxPaymentDates,
        uint[] memory paymentPercent
    ){

        require(maxPaymentDates.length == paymentPercent.length,"TOGGE: WRONG_PARAMS");
        poolSupplyMax = _poolSupplyMax;
        numberBorrowerTokens = _numberBorrowerTokens;
        borrower = _borrower;
        borrowerToken = _borrowerToken;
        reserveFactorMantissa = _reserveFactorMantissa;

        admin = _admin;

        for(uint tt = 0; tt < paymentPercent.length;tt++){
            Payment memory pay = new Payment({
                percet : paymentPercent[tt],
                maxDate : maxPaymentDates[tt],
                complete : false
            });
            payments.push(pay);
        }
        

    }


    //@Borrower -- deposit governance token 
    function depositdepositTokens(uint _value) external isBorrower {
        require(_value == numberBorrowerTokens,"TOGGE: NOT_APPROVED_VALUE");
        
        bool success = ERC20(borrowerToken).transferFrom(borrower,address(this),_value);
        require(success,"TOGGE: TRANSFER_FAILED");
        emit borrowerTokenDeposited(_value,address(this));

        startOfRaise = block.timestamp;
        endOfRaise = startOfRaise + 24 hours;
        endBorrowerAcceptWindow = endOfRaise + 4 hours;
        emit supplyVaultNowOpen(timeLimitSupply);
    }

    // @LP -- supply eth to main vault 
     function LP_deposit()external payable{

        require(msg.sender != borrower,"TOGGE: BORROWER_FORBIDDEN");

        uint _currentTime = block.timestamp;
        require(_currentTime > startOfRaise && _currentTime < endOfRaise,"TOGGE: OUT_OF_TIME_WINDOW");

        require(posiciones[msg.sender]==0,"already deposited");
        posiciones[msg.sender] += msg.value;
        if(accum.length!=0){
            uint temp = accum[currentIndex++]+msg.value;
            accum.push(temp);

        }else{ accum.push(msg.value);}
        emit ArrayVal(accum[currentIndex]);
        indexing[msg.sender] = currentIndex;
        emit Deposit(msg.sender,msg.value);

        // !!!! 
        ethSupplied += msg.value;
    }

     //@Borrower -- withdraw loan and create lp token
    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol) external isborrower{

        uint _currentTime = block.timestamp;
        require(_currentTime > endOfRaise && _currentTime < endBorrowerAcceptWindow,"TOGGE: OUT_OF_TIME_WINDOW");

        require(!loanAccepted,"TOGGE: LOAN_ALREADY_ACCEPTED");
        loanAccepted = true;

        (bool sent, ) =  payable(msg.sender).call{value: ethSupplied}("");
        require(sent, "TOGGE: FAILED_SEND");
        emit ethWithdrawBorrower(ethSupplied);

        createLPtoken(_name, _symbol);
    }

    //@System -- create LP token 
    function createLPtoken(string memory _name, string memory _symbol) internal { 
        LPnfts = new ggETH(_name,_symbol); 
    }

    //@LP -- withdarw deposit if failed loan
    function withdrawFailedDeposits() external { 

        require(!loanAccepted,"TOGGE: LOAN_ACCEPTED");
        require(posiciones[msg.sender]!= 0,"TOGGE: NO_VALUE");

 
        
        uint _deposit = posiciones[msg.sender];
        posiciones[msg.sender] = 0;
        (bool sent, ) =  payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
    }

    // LP -- mint lp token 
    function withdrawLPtoken() external {
        require(!loanAccepted,"TOGGE: LOAN_NOT_ACCEPTED");
        require(deposits[msg.sender]!= 0,"TOGGE: NO_VALUE");

        uint _currentTime = block.timestamp;
        require(_currentTime > endBorrowerAcceptWindow,"TOGGE: OUT_OF_TIME_WINDOW");

        for(uint tt = 0; tt < paymentPercent.length;tt++){
            payments[tt].val = payments[tt].percet*totalLoan*(10e-18);
        }
     

        // mint nft and save the posiciones balance in a balance mapping in ggeth 
    }



    // @LP - withdraw deposit + interest 
    function withdraw()external{
        uint index = indexing[msg.sender];
        bool primero = index==0&&accum[index]<=valorDAORecibido-valorRetiroLPs;
        bool segundo = true;
        uint yaSaco = 0;
        if(index>0){
            segundo = accum[index-1]<valorDAORecibido-valorRetiroLPs;//
            yaSaco = accum[index] - accum[index-1] - posiciones[msg.sender];
        }
        require(segundo||primero,"not eligible");
        require(posiciones[msg.sender]>0,"insufficient Funds");
        uint min=0;

        if(index>0){//si la diferencia es menor a lo que tiene el LP, entonces que el valor que pueda retirar sea esa diferencia menoor
            require(accum[index-1]+yaSaco<valorDAORecibido,"can't withdraw more");
            min =valorDAORecibido-accum[index-1]<posiciones[msg.sender]?valorDAORecibido-accum[index-1]:posiciones[msg.sender];
        }
        uint cantidadARetirar = index == 0?posiciones[msg.sender]:min;
        //cantidad ARetirar debe ser menor
        require(cantidadARetirar<=valorDAORecibido);
        posiciones[msg.sender]-=cantidadARetirar;
        emit Withdraw(msg.sender,cantidadARetirar);
        emit Withdraw(msg.sender,posiciones[msg.sender]);
        if(index>0)
            emit Withdraw(msg.sender,accum[index-1]);
        if(cantidadARetirar>0)
            payable(msg.sender).transfer(cantidadARetirar);
        emit balance(address(this).balance);
    }


    //@Borrower make loan payment 
    function makeLoanPayment() external isBorrower{
        
       uint _val = msg.val;
       require(_val > 0,"TOGGE: NO_VAL");
       require(_cpay.val >=_val,"TOGGE: EXCESS-PAYMENT");

       Payment memory _cpay = payments[pendingPayIndex];

       if(_cpay.val == _val){
           _cpay.complete = true;
           pendingPayIndex++;
       }else if(_cpay.val < _val){
           _cpay.val -= _val;
       }


    }


    //@Borrower -- withdraw tokens after payment of loan 
    function withdrawTokensBorrower()external isborrower{
        require(!LPnfts.exists,"TOGGE: ALREADY_MINT");
        require(indexing[msg.sender] != address(0),"TOGGE: NO_LP_POSITION");

        LPnfts.mint(msg.sender,indexing[msg.sender],posiciones[msg.sender]);
    }

    //@Liquidator call to start liquidation auction 
    function startAuction() external {

        

    }

    





}