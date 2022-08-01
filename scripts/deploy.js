const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    // We get the contract to deploy
    const Factory = await ethers.getContractFactory("FactoryBet");
    const factory = await Factory.deploy();
    console.log("Factory deployed to:", factory.address);
    await factory.initialize();
    await factory.setTest(10);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });