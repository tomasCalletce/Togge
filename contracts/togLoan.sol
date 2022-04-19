// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ggeth.sol";
import "./InterestRateModel.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract togLoanStorage {}

contract togLoan {
    // open vault to investors
    event borrowerTokenDeposited(uint256 _amount, address borrower);

    event supplyVaultNowOpen(uint256 _timeLimit);

    event ethWithdrawBorrower(uint256 _value);

    // $$$$ MUST CHANGE NAMES $$$$

    event Deposit(address, uint256);

    event ArrayVal(uint256);

    event Withdraw(address, uint256);

    event balance(uint256);

    // $$$$ MUST CHANGE NAMES $$$$

    // loan accepted
    bool public loanAccepted;

    // Loan Maker / admin
    address public immutable admin;

    // borrower governance token
    address public borrowerToken;

    // borrower address
    address public borrower;

    //address of dao
    address public dao;

    // promised number of borrower tokens
    uint256 public numberBorrowerTokens;

    // max supply eth
    uint256 public poolSupplyMax;

    // time limit supply ETH to vault
    uint256 public endOfRaise;

    // time start supply ETH to vault
    uint256 public startOfRaise;

    // end time for DAO to accept loan
    uint256 public endBorrowerAcceptWindow;

    // eth supplied
    uint256 public ethSupplied;

    // $$$$ MUST CHANGE NAMES $$$$

    // amount paid
    uint256 public valorDAORecibido = 0;

    // amount withdrawn
    uint256 public valorRetiroLPs = 0;

    // current lp index
    uint256 public currentIndex = 0;

    //reserveFactorMantissa
    uint256 public reserveFactorMantissa;

    //index order of each LP
    mapping(address => uint256) indexing;

    // deposit balance by LP
    mapping(address => uint256) deposits;

    // lp seniority manager
    uint256[] accum;

    // $$$$ MUST CHANGE NAMES $$$$

    ERC721 public LPnfts;

    // caller is
    modifier isBorrower() {
        require(msg.sender == dao);
        _;
    }

    // caller is admin
    modifier isadmin() {
        require(msg.sender == admin);
        _;
    }

    constructor(
        uint256 _poolSupplyMax,
        uint256 _numberBorrowerTokens,
        uint256 _reserveFactorMantissa,
        address _borrower,
        address _borrowerToken,
        address _admin
    ) {
        poolSupplyMax = _poolSupplyMax;
        numberBorrowerTokens = _numberBorrowerTokens;
        borrower = _borrower;
        borrowerToken = _borrowerToken;
        reserveFactorMantissa = _reserveFactorMantissa;

        admin = _admin;
    }

    //@Borrower -- deposit governance token
    function depositTokens(uint256 _value) external isBorrower {
        require(_value == numberBorrowerTokens, "TOGGE: NOT_APPROVED_VALUE");

        bool success = ERC20(borrowerToken).transferFrom(
            borrower,
            address(this),
            _value
        );
        require(success, "TOGGE: TRANSFER_FAILED");
        emit borrowerTokenDeposited(_value, address(this));

        startOfRaise = block.timestamp;
        endOfRaise = startOfRaise + 24 hours;
        endBorrowerAcceptWindow = endOfRaise + 4 hours;
        emit supplyVaultNowOpen(endOfRaise);
    }

    // @LP -- supply eth to main vault
    function LP_deposit() external payable {
        require(msg.sender != borrower, "TOGGE: BORROWER_FORBIDDEN");

        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > startOfRaise && _currentTime < endOfRaise,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );

        require(deposits[msg.sender] == 0, "already deposited");
        deposits[msg.sender] += msg.value;
        if (accum.length != 0) {
            uint256 temp = accum[currentIndex++] + msg.value;
            accum.push(temp);
        } else {
            accum.push(msg.value);
        }
        emit ArrayVal(accum[currentIndex]);
        indexing[msg.sender] = currentIndex;
        emit Deposit(msg.sender, msg.value);

        // !!!!
        ethSupplied += msg.value;
    }

    //@Borrower -- withdraw loan and create lp token
    function acceptLoanWithdrawLoan(string memory _name, string memory _symbol)
        external
        isBorrower
    {
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > endOfRaise && _currentTime < endBorrowerAcceptWindow,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );

        require(!loanAccepted, "TOGGE: LOAN_ALREADY_ACCEPTED");
        loanAccepted = true;

        (bool sent, ) = payable(msg.sender).call{value: ethSupplied}("");
        require(sent, "TOGGE: FAILED_SEND");
        emit ethWithdrawBorrower(ethSupplied);

        createLPtoken(_name, _symbol);
    }

    //@System -- create LP token
    function createLPtoken(string memory _name, string memory _symbol)
        internal
    {
        LPnfts = new ggETH(_name, _symbol);
    }

    //@LP -- withdarw deposit if failed loan
    function withdrawFailedDeposits() external {
        require(!loanAccepted, "TOGGE: LOAN_ACCEPTED");
        require(deposits[msg.sender] != 0, "TOGGE: NO_VALUE");

        uint256 _deposit = deposits[msg.sender];
        deposits[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
    }

    //BULLSHIT
    // // LP -- mint lp token
    // function withdrawLPtoken() external {
    //     require(!loanAccepted, "TOGGE: LOAN_NOT_ACCEPTED");
    //     require(deposits[msg.sender] != 0, "TOGGE: NO_VALUE");

    //     uint256 _currentTime = block.timestamp;
    //     require(
    //         _currentTime > endBorrowerAcceptWindow,
    //         "TOGGE: OUT_OF_TIME_WINDOW"
    //     );

    //     // mint nft and save the deposits balance in a balance mapping in ggeth
    // }

    // @LP - withdraw deposit + interest
    function withdraw() external {
        uint256 index = indexing[msg.sender];
        bool primero = index == 0 &&
            accum[index] <= valorDAORecibido - valorRetiroLPs;
        bool segundo = true;
        uint256 yaSaco = 0;
        if (index > 0) {
            segundo = accum[index - 1] < valorDAORecibido - valorRetiroLPs; //
            yaSaco = accum[index] - accum[index - 1] - deposits[msg.sender];
        }
        require(segundo || primero, "not eligible");
        require(deposits[msg.sender] > 0, "insufficient Funds");
        uint256 min = 0;

        if (index > 0) {
            //si la diferencia es menor a lo que tiene el LP, entonces que el valor que pueda retirar sea esa diferencia menoor
            require(
                accum[index - 1] + yaSaco < valorDAORecibido,
                "can't withdraw more"
            );
            min = valorDAORecibido - accum[index - 1] < deposits[msg.sender]
                ? valorDAORecibido - accum[index - 1]
                : deposits[msg.sender];
        }
        uint256 cantidadARetirar = index == 0 ? deposits[msg.sender] : min;
        //cantidad ARetirar debe ser menor
        require(cantidadARetirar <= valorDAORecibido);
        deposits[msg.sender] -= cantidadARetirar;
        emit Withdraw(msg.sender, cantidadARetirar);
        emit Withdraw(msg.sender, deposits[msg.sender]);
        if (index > 0) emit Withdraw(msg.sender, accum[index - 1]);
        if (cantidadARetirar > 0)
            payable(msg.sender).transfer(cantidadARetirar);
        emit balance(address(this).balance);
    }

    //@Borrower make loan payment
    function makeLoanPayment() external {}

    //@Borrower -- withdraw tokens after payment of loan
    function withdrawTokensBorrower() external isBorrower {}
}
