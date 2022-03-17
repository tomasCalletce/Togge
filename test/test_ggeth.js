const { expect } = require('chai');

describe("ggEth", function(){

    it("all correct", async function(){

        const myContract = await hre.ethers.getContractFactory('ggETH');

        const contractDeployed = await myContract.deploy("TOGGELOANTOKEN","GGETH");

        await contractDeployed.deployed();

        expect(await contractDeployed.name()).to.equal("TOGGELOANTOKEN");

    });

})