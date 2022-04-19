// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("createDAOTokens", function () {
//   //3 addresses


//   it("Dao Tokens", async function () {
//     const [owner, addr1, addr2] = await ethers.getSigners();
//     const DaoToken = await ethers.getContractFactory("DaoToken");
//     const token = await DaoToken.deploy(1000);
//     await token.deployed();
//     // console.log(addr1.address)
//     const val = expect(await token.transfer(addr1.address, 100));
//     console.log(await token.balanceOf(addr1.address))
//     console.log(await token.balanceOf(owner.address))
//     console.log(token.address)//address of ERC20 contract to start the loan 
//     const LoanMaker = await ethers.getContractFactory("LoanMaker");
//     const makeLoan = await LoanMaker.deploy(100000, 100, 1, addr1, token.address, owner);
//   })
// })
