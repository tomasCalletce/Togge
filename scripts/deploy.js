async function main() {
    // We get the contract to deploy
    const DaoToken = await ethers.getContractFactory("DaoToken");
    const daoT = await DaoToken.deploy(3000);

    await greeter.deployed();

    console.log("Greeter deployed to:", greeter.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });