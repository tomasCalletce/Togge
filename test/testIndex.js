const { expect } = require("chai");
const { ethers } = require("hardhat");

function multe18(num ){
    return ethers.utils.parseUnits(String(num)); 
}



describe("Togge", function () {

    let dao;
    let lp;
    let admin;
    let user;

    let LoanMaker;
    let LoanMakerContract;
    
    let ggLoan;

    let daoToken;
    let daoTokenContract;

    let xToken;

    before(async function () {
        [dao,lp,admin,user] = await ethers.getSigners();
        daoTokenContract = await ethers.getContractFactory("DaoToken");
        daoToken = await daoTokenContract.connect(dao).deploy(multe18(1000));
        await daoToken.deployed();
    })


    describe("Make contracts and utils",function(){

        it("Make Loan Maker", async function () {
            LoanMakerContract = await ethers.getContractFactory("LoanMaker");
            LoanMaker = await LoanMakerContract.deploy();
            await LoanMaker.deployed();
            expect(LoanMaker);
    
        })
    
        it("Make ggLoan", async function () {
            await LoanMaker.createLoan(multe18(1000),multe18(100),multe18(1), dao.address, daoToken.address, admin.address);
            const ggLoanAddress = await LoanMaker.allLoans(0);
            const loanContractOBJ = await hre.ethers.getContractFactory('togLoan');
            ggLoan = await await loanContractOBJ.attach(ggLoanAddress);
            expect(ggLoan)
        })
    
        it("ggLoan can spend daoTokens", async function () {
           await daoToken.connect(dao).approve(ggLoan.address,multe18(100));
           const allowence = await daoToken.connect(dao).allowance(dao.address,ggLoan.address);
           expect(ethers.utils.formatEther(allowence) === 500.0);
        })

    })

    describe("togLoan",function(){

        it("deposit dao tokens", async function () {
            expect(await ggLoan.connect(dao).depositTokens(multe18(100)));
        })

        it("different value of daoTokens", async function () {
            try {
                await ggLoan.connect(dao).depositTokens(multe18(10))
            } catch (error) {
                expect(true);
            }
        })

        it("deposit ", async function () {
            try {
                await ggLoan.connect(dao).depositTokens(multe18(10))
            } catch (error) {
                expect(true);
            }
        })

    })



  
 

})

// await greeter.connect(addr1).setGreeting("Hallo, Erde!");