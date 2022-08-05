const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const address = '0xF346fc01c68741F7cD018fc91ca8E34ddB4E7Ad9';
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