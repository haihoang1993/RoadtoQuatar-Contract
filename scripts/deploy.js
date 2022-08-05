const hre = require("hardhat");
const ethers = hre.ethers;
const contractDeployed = require('../deployed.json')
const data = require('../live.json');

async function main() {
    const [adrss]= await ethers.getSigners();
    console.log('data:',data)
    // We get the contract to deploy
    const Factory = await ethers.getContractFactory("FactoryBet");
    const factory = await Factory.deploy();
    console.log("Factory deployed to:", factory.address);
    await factory.initialize();
    const owner = await factory.owner();
    console.log('address',adrss.address);
    console.log('owner',owner);
    
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });