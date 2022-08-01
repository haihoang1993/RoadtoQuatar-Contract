const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const address = '0xf51c18E0A0377BEDD7E96E30cECc299e17cDC90d';
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