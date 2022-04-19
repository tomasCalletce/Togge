const { expect } = require("chai");
const { ethers } = require("hardhat");

function multe18(num ){
    return ethers.utils.parseUnits(String(num)); 
}



describe("Togge", async function () {

    let dao;
    let lp;
    let admin;
    let user;

    let LoanMaker;
    let LoanMakerContract;
    
    let ggLoan;

    let daoToken;
    let daoTokenContract;

    before(async function () {
        [dao,lp,admin,user] = await ethers.getSigners();
        daoTokenContract = await ethers.getContractFactory("DaoToken");
        daoToken = await daoTokenContract.connect(dao).deploy(multe18(1000));
        await daoToken.deployed();
    })

    it("Make Loan Maker", async function () {
        LoanMakerContract = await ethers.getContractFactory("LoanMaker");
        LoanMaker = await LoanMakerContract.deploy();
        await LoanMaker.deployed();
        const ggLoanIndex =  await LoanMaker.createLoan(multe18(1000),multe18(100),multe18(1), dao.address, daoToken.address, admin.address);
        const ggLoanIndexVal = ethers.BigNumber.from(ggLoanIndex.value);
        console.log(ethers.utils.formatEther(ggLoanIndexVal));
    })

    it("deposit DAO tokens", async function () {
        console.log(ggLoan)
    })

})

// await greeter.connect(addr1).setGreeting("Hallo, Erde!");