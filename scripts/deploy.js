const hre = require("hardhat");

function multe18(num ){
  return ethers.utils.parseUnits(String(num)); 
}

async function main() {

    [dao,admin] = await ethers.getSigners();

    const DaoToken = await deployDaoToken(dao);
    //const GGLoanMaker = await deployGGLoanMaker(DaoToken);

    console.log("DAOtoken deployed to:", DaoToken.address);
    //console.log("LoanMaker deployed to:", GGLoanMaker.address);
}

async function deployGGLoanMaker(DaoToken){
    const numberBorrowerTokens = String(100*10**18);
    const reserveFactorMantissa = String(.1*10**18);
    const duracionCiclo = "604800"; // 1 week
    const numCiclos = 10;
    const goalAmount = ethers.utils.parseEther("1000").toString();
    const multiplier = String(30*10**18);
    const discountRate = ethers.utils.parseEther(".1").toString();
    const auctionDuration = "86400"; // 24 hours
    const borrower = dao.address; // 18 
    const borrowerToken = DaoToken.address;
    const loanAdmin = admin.address; // 19 
    const structInput = `[${numberBorrowerTokens},${reserveFactorMantissa},${duracionCiclo},
    ${numCiclos},${goalAmount},${multiplier},${discountRate},${auctionDuration},${borrower},${borrowerToken},
    ${loanAdmin}]`

    const LoanMakerContract = await ethers.getContractFactory("GGLoanMaker");
    const LoanMaker = await LoanMakerContract.connect(admin).deploy();
    await LoanMaker.deployed();
    return LoanMaker;
}

async function deployDaoToken(dao){
  const daoTokenContract = await ethers.getContractFactory("DaoToken");
  const daoToken = await daoTokenContract.connect(dao).deploy(multe18(1000));
  await daoToken.deployed();
  return daoToken;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
