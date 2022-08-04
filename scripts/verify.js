const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
    const address = '0xece209b640E6AAbb90BD0E5422C44d3dBd83aF4D';
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