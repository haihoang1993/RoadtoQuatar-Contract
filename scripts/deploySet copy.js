const hre = require("hardhat");
const ethers = hre.ethers;


async function main() {
    const totalSupply = ethers.utils.parseEther("5000000000");
    const GetToken = await ethers.getContractFactory("GetToken");
    const contractGet= await GetToken.attach('0xE4493cc896633Fe6f7B9C8f1e8727C6b2c5A4940');
    const data= await contractGet.token();

    console.log('data:',data);
  

}



main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });