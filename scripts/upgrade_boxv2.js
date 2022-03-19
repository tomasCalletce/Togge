
// scripts/upgrade_box.js
const { ethers, upgrades } = require("hardhat");

const PROXY = "0x578f39221387837b569404125cc0AAB7A9aAEebc";

async function main() {
    const BoxV2 = await ethers.getContractFactory("BoxV2");
    console.log("Upgrading Box...");
    await upgrades.upgradeProxy(PROXY, BoxV2);
    console.log("Box upgraded");
}

main();