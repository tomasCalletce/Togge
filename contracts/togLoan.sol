// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ggeth.sol";

contract togLoanStorage {

}

contract togLoan {

    // open vault to investors
    event borrowerTokenDeposited(uint _amount);

    event supplyVaultNowOpen(timeLimit);

    // $$$$ MUST CHANGE NAMES $$$$

    event Deposit(address,uint);

    event ArrayVal(uint);

    event Withdraw(address,uint);

    event balance(uint);

    // $$$$ MUST CHANGE NAMES $$$$

    // loan accepted 
    bool public loanAccepted;

    // Loan Maker / admin 
    address public immutable admin;

     // Fraction of interest currently set aside for reserves
    uint public reserveFactorMantissa;

    // Block number that interest was last accrued at
    uint public accrualBlockNumber;

   // Total amount of reserves of the underlying held in this market
    uint public totalReserves;

    // borrower governance token
    address public  borrowerToken;

    // borrower address
    address public  borrower;

    // promised number of borrower tokens
    uint public numberBorrowerTokens;
    
    // max supply eth 
    uint public poolSupplyMax;

    // time limit supply 
    uint public timeLimitSupply;

    // eth supplied 
    uint public ethSupplied;


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
    uint[] accum;

    // $$$$ MUST CHANGE NAMES $$$$

    ERC20 public LPtoken;
    
    // caller is 
    modifier isBorrower(){
        require(msg.sender == dao);
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
        address _admin
    ){
        poolSupplyMax = _poolSupplyMax;
        numberBorrowerTokens = _numberBorrowerTokens;
        borrower = _borrower;
        borrowerToken = _borrowerToken;
        reserveFactorMantissa = _reserveFactorMantissa;

        admin = _admin;
    }


    // @Borrower - deposit governance token 
    function depositdepositTokens(uint _value) external isBorrower {
        require(_value == numberBorrowerTokens,"TOGGE: NOT_TOKEN");
        
        bool success = IERC20(borrowerToken).transferFrom(borrower,address(this),_value);
        require(success,"TOGGE: TRANSFER_FAILED");
        emit borrowerTokenDeposited(_value,address(this));

        timeLimitSupply = block.timestamp + 24 hours;
        emit supplyVaultNowOpen(timeLimitSupply);
    }

    // @LP - supply eth to main vault 
     function LP_deposit()external payable{
        require(posiciones[msg.sender]==0,"already deposited");
        posiciones[msg.sender] += msg.value;
        if(accum.length!=0){
            uint temp = accum[currentIndex++]+msg.value;
            accum.push(temp);

        }else{ accum.push(msg.value);}
        emit ArrayVal(accum[currentIndex]);
        indexing[msg.sender] = currentIndex;
        emit Deposit(msg.sender,msg.value);
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

    // @LP -- withdraw lp token
    function withdrawLPtoken() external {

        require(deposits[msg.sender]!= 0,"TOGGE: NO_VALUE");
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken.mint(msg.sender,deposits[msg.sender]);
    }

    // @LP -- withdarw deposit if failed
    function withdrawFailedDeposits() external { 

        require(deposits[msg.sender]!=0,"TOGGE: NO_VALUE");
        require(amount<total,"TOGGE: OVER_MAX");
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");

        uint _deposit = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool sent, ) =  payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
    }

    // @Borrower make loan payment 
    function makeLoanPayment()external{
        valorDAORecibido+=400;
    }


    //  @Borrower -- withdraw tokens after payment of loan 
    function withdrawTokensBorrower()external isborrower{
    
        require(amount<total,"TOGGE: OVER_MAX");
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        

        bool _respo = IERC20(token).transfer(dao,nTokens);
        require(_respo, "TOGGE: FAILED_SEND");
        emit tokenWithdraw(dao,nTokens);
    }

    //  @Borrower -- withdraw loan and create lp token
    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol) external isborrower{

        loanAccepted = true;
        require(!loanAccepted,"TOGGE: LOAN_ALREADY_ACCEPTED");

        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");
        require(!withdrawed);

        withdrawed = !withdrawed;
        uint _amount = amount;

        (bool sent, ) =  payable(msg.sender).call{value: _amount}("");
        require(sent, "TOGGE: FAILED_SEND");
        emit ethWithdraw(amount);

        createLPtoken(_name, _symbol);
    }

    //  @System -- create LP token 
    function createLPtoken(string memory _name, string memory _symbol) internal { 
        //We create the LP token that represents the share of the pool the LP owns
        require(block.timestamp>timeLimit,"TOGGE: NOT_END");
        require(amount == total,"TOGGE: OVER_MAX");

        LPtoken = new ggETH(_name,_symbol); 
        emit LPtokencreated(address(LPtoken));
    }

}

