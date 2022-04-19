const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("createDAOTokens", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const token = null;
    before("szs", async function () {
        const DaoToken = await ethers.getContractFactory("DaoToken");
        token = await DaoToken.deploy(1000);
        await token.deployed();
    })

    it("Dao Tokens", async function () {
        // console.log(addr1.address)
        console.log(token);
        const val = expect(await token.transfer(addr1.address, 100));
        console.log(await token.balanceOf(addr1.address))
        console.log(await token.balanceOf(owner.address))
        console.log(token.address)//address of ERC20 contract to start the loan 
        const LoanMaker = await ethers.getContractFactory("LoanMaker");
        const makeLoan = await LoanMaker.deploy();
        await makeLoan.deployed();
        const loan1 = await makeLoan.createLoan(100000, 100, 1, addr1.address, token.address, owner.address);
        console.log(loan1);
        console.log(szs);
    })
})

// await greeter.connect(addr1).setGreeting("Hallo, Erde!");