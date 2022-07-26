const { ethers, upgrades } = require('hardhat');

async function main() {
    // We get the contract to deploy
    const feeLock = ethers.utils.parseEther("0.01");
    const MirLock = await ethers.getContractFactory("MirLock");
    const MirLockProxy = await upgrades.deployProxy(MirLock, [feeLock], { kind: 'uups' });
    console.log("MirLock deployed to:", MirLockProxy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });