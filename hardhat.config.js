require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
const key = [
    "69f81329c3d7b4fb26dd7be1a3631abf34bdd40e59b1444b05207c2ba532571c",
    "14c83ac894209281cf0d6ba5fcd7c413b789d060741b2723f62aed25c31dc246"
];
const key_mainnet = "69f81329c3d7b4fb26dd7be1a3631abf34bdd40e59b1444b05207c2ba532571c";

const KEY_API = "NEYUDDVT6K46JEIWPIHIU2PXR5VIKUZB7H"

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();

    for (const account of accounts) {
        const balance = await account.getBalance();
        console.log(`${account.address} has ${hre.ethers.utils.formatEther(balance)} ETH`);
    }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat",
    etherscan: {
        apiKey: {
            bsc: KEY_API,
            bscTestnet: KEY_API,
        }
    },
    networks: {
        hardhat: {
            gas: 12000000,
            blockGasLimit: 0x1fffffffffffff,
            allowUnlimitedContractSize: true,
            timeout: 1800000
        },
        localhost: {
            url: "http://127.0.0.1:8545",
            gas: 12000000,
            blockGasLimit: 0x1fffffffffffff,
            allowUnlimitedContractSize: true,
            timeout: 1800000
        },
        bscTestnet: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545",
            accounts: key
        },
        bsc: {
            url: "https://bsc-dataseed1.ninicoin.io",
            accounts: [key_mainnet]
        }
    },
    solidity: {
        compilers: [
            {
                version: "0.8.11",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 100
                    }
                },
            },
            {
                version: "0.5.16",
            },
            {
                version: "0.4.18",
            }
        ],
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        },
        overrides: {
            "contracts/DemoSwapFactory.sol": {
                version: "0.5.16",
                settings: {}
            },
            "contracts/WBNB.sol": {
                version: "0.4.18",
                settings: {}
            },
        }
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts"
    },
    mocha: {
        timeout: 40000
    }
}