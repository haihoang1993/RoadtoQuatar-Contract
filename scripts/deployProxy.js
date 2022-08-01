const { ethers, upgrades, network } = require('hardhat');
const JSONdb = require('simple-json-db');
const db = new JSONdb('./deployed.json');
async function main() {
    // We get the contract to deploy
    const Factory = await ethers.getContractFactory("FactoryBet");
    const factoryProxy = await upgrades.deployProxy(Factory, [ethers.utils.parseEther("0.01"), 2], { kind: 'uups' });
    console.log("Factory deployed to:", factoryProxy.address);
    const key = `${network.name}.proxyMirFactoryAddress`;
    db.set(key, factoryProxy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });