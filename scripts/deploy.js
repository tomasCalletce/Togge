const { Contract } = require("ethers");
const hre = require("hardhat");

function multe18(num) {
  return ethers.utils.parseUnits(String(num));
}

async function main() {

  [dao, admin] = await ethers.getSigners();

  const DaoToken = await deployDaoToken(dao);

  const DepoManager = await deployContract(admin, "DepoManager");
  const PaymentManager = await deployContract(admin, "PaymentManager");
  const WithdrawManager = await deployContract(admin, "WithdrawManager");

  const LiquidationManager = await deployContract(admin, "LiquidationManager");

  const GGLoanMaker = await deployGGLoanMaker(DepoManager, PaymentManager, WithdrawManager, admin);
  const ggLoan = await makeLoan(DaoToken, GGLoanMaker, dao, admin);
  const loanAddress = await GGLoanMaker.loans(0)
  await DaoToken.approve(loanAddress, multe18(1000));


  console.log("DAOtoken deployed to:", DaoToken.address);
  console.log("LoanMaker deployed to:", GGLoanMaker.address);
}

async function makeLoan(DaoToken, GGLoanMaker, dao, admin) {
  const numberBorrowerTokens = String(100 * 10 ** 18);
  const reserveFactorMantissa = String(.1 * 10 ** 18);
  const goalAmount = ethers.utils.parseEther("1000").toString();
  const multiplier = String(30 * 10 ** 18);
  const discountRate = ethers.utils.parseEther(".1").toString();
  const borrower = dao.address; // 18 
  const borrowerToken = DaoToken.address;
  const loanAdmin = admin.address; // 19 


  return await GGLoanMaker.connect(admin).makeLoan(numberBorrowerTokens, reserveFactorMantissa, goalAmount, multiplier, discountRate, borrower, borrowerToken, loanAdmin);
}
async function deployGGLoanMaker(DepoManager, PaymentManager, WithdrawManager, admin) {
  const LoanMakerContract = await ethers.getContractFactory("GGLoanMaker", {
    libraries: {
      DepoManager: DepoManager.address,
      PaymentManager: PaymentManager.address,
      WithdrawManager: WithdrawManager.address,
    }
  });
  const LoanMaker = await LoanMakerContract.connect(admin).deploy();
  await LoanMaker.deployed();
  return LoanMaker;
}
async function deployDaoToken(dao) {
  const daoTokenContract = await ethers.getContractFactory("DaoToken");
  const daoToken = await daoTokenContract.connect(dao).deploy(multe18(1000));
  await daoToken.deployed();
  return daoToken;
}
async function deployContract(admin, contract) {
  const LibrarieContract = await ethers.getContractFactory(contract);
  const instance = await LibrarieContract.connect(admin).deploy();
  await instance.deployed();
  return instance;
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
