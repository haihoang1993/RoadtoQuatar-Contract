const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const address = '0x7eAF7ee4B26F69CEA04C70aECf728b33aaADfe04';
    await hre.run("verify:verify", {
        address: address,
        constructorArguments: [],
    });
    console.log("Factory verified to:", address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });