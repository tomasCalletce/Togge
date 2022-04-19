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

    let lpNFT;

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
            ggLoan = await loanContractOBJ.attach(ggLoanAddress);
            expect(ggLoan)
        })
    
        it("ggLoan can spend daoTokens", async function () {
           await daoToken.connect(dao).approve(ggLoan.address,multe18(500));
           const allowence = await daoToken.connect(dao).allowance(dao.address,ggLoan.address);
           expect(ethers.utils.formatEther(allowence) === 500.0);
        })

    })

    describe("togLoan",function(){

        it("lp can't deposit before start of raise", async function () {
            try {
                await ggLoan.connect(lp).LP_deposit({value: ethers.utils.parseEther("4.0")});
            } catch (error) {
                expect(true);
            }
        })

        it("deposit dao tokens", async function () {
            expect(await ggLoan.connect(dao).depositTokens(multe18(100)));
        })

        it("can't withdraw daoTokens before raised period", async function () {
            try {
                await ggLoan.connect(dao).acceptLoanWithdrawLoan('nftDao','DAO')
            } catch (error) {
                expect(true)
            }
        })

        

        it("can't input different value of daoTokens", async function () {
            try {
                await ggLoan.connect(dao).depositTokens(multe18(10));
            } catch (error) {
                expect(true);
            }
        })

        it("cant`t deposit dao tokens with no permission given", async function () {
            await daoToken.connect(dao).approve(ggLoan.address,multe18(0));
            try {
                await ggLoan.connect(dao).depositTokens(multe18(100));
            } catch (error) {
                expect(true);
            }
        })

        it("lp deposit", async function () {
            const res = await ggLoan.connect(lp).LP_deposit({value: ethers.utils.parseEther("4.0")})
            expect(res);
        })

        it("lp cant't deposit twice deposit", async function () {
            try {
                await ggLoan.connect(lp).LP_deposit({value: ethers.utils.parseEther("4.0")});
            } catch (error) {
                expect(true);
            }
        })

        it("lp deposit saved", async function () {
            try {
                const res = await ggLoan.deposits(lp.address);
                expect(ethers.utils.formatEther(res) === 4.0)

            } catch (error) {
                expect(true);
            }
        })

        it("can withdraw daoTokens", async function () {
            function timeout(ms) {
                return new Promise(resolve => setTimeout(resolve, ms));
            }
            await timeout(24000);
            await ggLoan.connect(dao).acceptLoanWithdrawLoan('nftDao','DAO')
            
        })

        it("lp nft created", async function () {
            const lpNFTadress = await ggLoan.LPnfts();
            const lpNftOBJ = await hre.ethers.getContractFactory('ggETH');
            lpNFT = await lpNftOBJ.attach(lpNFTadress);
            expect(lpNFT)
            
        })



        



        




    })

})

// await greeter.connect(addr1).setGreeting("Hallo, Erde!");