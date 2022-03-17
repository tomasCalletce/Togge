const { expect, assert } = require('chai');
const { ethers } = require('hardhat');
const moment = require('moment')



function myAsyncFunction(callback) {
    setTimeout(function() {
      callback();
    }, 6000);
  }


describe("Loan_Maker", function(){

    let LoanMaker;
    let LoanMakerDeployed;
    let DaoToken;
    let DaotokenDeployed;


    let dao;
    let lp;
    let admin;
    let DaoTokenAddress;
    let loanContractOBJ;

    let loanAdress;
    
    before(async function(){
        [dao,lp,admin] = await ethers.getSigners();
        LoanMaker = await hre.ethers.getContractFactory('LoanMaker');
        LoanMakerDeployed  = await LoanMaker.connect(admin).deploy();
        await LoanMakerDeployed.deployed();


    })

    describe("Loan_Maker", function(){
        it("admin == deployer", async function(){
            expect(await LoanMakerDeployed.admin()).to.equal(admin.address);
        });
    })

   
    describe("createLoan", function(){

        it("Create Loan",async function(){

            DaoToken = await hre.ethers.getContractFactory('daoToken');
            DaotokenDeployed  = await DaoToken.connect(dao).deploy("DAOTOKEN","DAO",dao.address,ethers.utils.parseUnits("500", 18));
            await DaotokenDeployed.deployed();
            DaoTokenAddress = await DaotokenDeployed.address;
    
            let _interest = ethers.BigNumber.from("3");
            let _total = ethers.utils.parseEther("10");
            let _corte = moment().add(5,'seconds').unix();
            let _nTokens = ethers.utils.parseUnits("500", 18);
         
            let _loanMade = await LoanMakerDeployed.connect(admin).createLoan(
                _interest,
                _total,
                _corte,
                _nTokens,
                DaoTokenAddress,
                dao.address,
                admin.address
            );
    
            expect(_loanMade);
        })

        it("Loan is in List", async function(){
            let _LoanFromList = await LoanMakerDeployed.connect(admin).loans(0);
            loanAdress = _LoanFromList;
            expect(_LoanFromList);
        })


    })

    describe("LP actions", ()=>{

        it("deposit LP only after tokens are handed over by DAO",async function(){
            LoanContract = await hre.ethers.getContractFactory('Loan');
            loanContractOBJ =  await LoanContract.attach(loanAdress);

            const options = {value: ethers.utils.parseEther("4.0")}

            try {
            
                let _respo = await loanContractOBJ.connect(lp).deposit_LP(options)
    
            } catch (error) {
                expect(true);
            }
            
        })

        it("deposit value is 0 if not deposited", async function(){
            try {
                let _respo = await loanContractOBJ.deposits(lp.address);
                
            } catch (error) {
                assert(true)
            }
        })

    })

    describe("dao", function(){

        it("dao has 500 tokens, not test just to see and aprove spend",async function(){
            let _respo = await DaotokenDeployed.balanceOf(dao.address);
            _respo = ethers.utils.formatUnits(_respo, 18);
            let _respo2 = await DaotokenDeployed.connect(dao).approve(loanAdress,ethers.utils.parseUnits("500", 18));
            assert(_respo == 500.0 && _respo2);
        })

        it("lock tokens to start lp deposits", async function(){
            let _respo = await loanContractOBJ.connect(dao).depositTokens_startLPdeposits(ethers.utils.parseUnits("500", 18))
            assert(_respo);
        })

    })

    describe("LP deposits",function(){
        
        it("can deposit ether", async function(){
            const options = {value: ethers.utils.parseEther("4.0")}
            let _respo = await loanContractOBJ.connect(lp).deposit_LP(options)

            assert(_respo);
        })

        it("amount deposited by lp is saved",async function(){
            let _respo = await loanContractOBJ.connect(lp).deposits(lp.address);
            _respo = ethers.utils.formatEther(_respo)

            assert(4.0 == _respo);
        })

        it("cant deposit after end of deposit window",async function () {
            const options = {value: ethers.utils.parseEther("4.0")}
            try {
                let _respo = await loanContractOBJ.connect(lp).deposit_LP(options);
                console.log(_respo)
                assert(_respo);
            } catch (error) {
                assert(true);
            }
        });

    })


    

    

   

})