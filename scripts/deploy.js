const { ethers } = require("hardhat");

async function main() {

    const DaoToken = await ethers.ContractFactory("Test");
    const daoToken = await DaoToken.deploy();
    await daoToken.deployed()
    console.log("DAO token: " + daoToken.address);

//     const numberBorrowerTokens = String(100*10**18);
//     const reserveFactorMantissa = String(.1*10**18);
//     const duracionCiclo = "604800"; // 1 week
//     const numCiclos = 10;
//     const goalAmount = ethers.utils.parseEther(1000).toString();
//     const multiplier = String(30*10**18);
//     const discountRate = ethers.utils.parseEther(.1).toString();
//     const auctionDuration = "86400" // 24 hours
//     const borrower = "0xdd2fd4581271e230360230f9337d5c0430bf44c0" // 18 
//     const borrowerToken = 
//     const loanAdmin = "0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199"; // 19 

//     const structInput = "["

 

//     const LoanMaker = await ethers.getContractFactory("ggLoanMaker");
//     const loanMaker = await LoanMaker.deploy("");

//   await greeter.deployed();

}

main();