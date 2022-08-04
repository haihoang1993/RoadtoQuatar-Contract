const hre = require("hardhat");
const ethers = hre.ethers;


async function main() {
    const totalSupply = ethers.utils.parseEther("5000000000");
    // const DemoToken = await ethers.getContractFactory("DemoToken");
    const GetToken = await ethers.getContractFactory("GetToken");
    // const instanceToken = await DemoToken.deploy("SPORTSBETTING", "SPB", totalSupply);
    // console.log('token deployed',instanceToken.address);
    const instanceGet = await GetToken.deploy("0xFF4b590A703d56221288dfDAE7367f05C3ab2A62");
    // await instanceToken.transfer(instanceGet.address,ethers.utils.parseEther("20000"))
    console.log('get token deployed:', instanceGet.address);

}



main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });