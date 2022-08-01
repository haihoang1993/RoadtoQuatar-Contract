const { ethers, upgrades, network } = require('hardhat');
const JSONdb = require('simple-json-db');
const db = new JSONdb('./deployed.json');
async function main() {
    // We get the contract to deploy
    const key = `${network.name}.proxyMirFactoryAddress`;
    if(db.has(key)){
        const proxyMirFactoryAddress = db.get(key);
        const Factory = await ethers.getContractFactory("Factory");
        await upgrades.upgradeProxy(proxyMirFactoryAddress, Factory);
        console.log("Factory upgraded successfully");
    }else{
        console.error("ProxyMirFactoryAddress not found in db");
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });