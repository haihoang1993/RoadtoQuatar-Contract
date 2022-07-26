const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const address = '0x6209CdE9A1B293aB80E993e719fAb4DB804F09cc';
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