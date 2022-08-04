const BN = require('bn.js')
const { ethers, upgrades } = require('hardhat');
const { expect } = require('chai');
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
describe("FactoryBet",  function () {

  let instanceToken, instanceFactory;
  const totalSupply = ethers.utils.parseEther("1000000");
  const tokenPerBnb = ethers.utils.parseEther("10000");
  const timeStart = Math.floor(Date.now() / 1000) + 86400;
  // set timeEnd to 2 days from now
  const timeEnd = Math.floor(Date.now() / 1000) + 172800;

  console.log("timeStart: ", timeStart);

  const bet = {
    id:0,
    addressBet: "0x0000000000000000000000000000000000001000",
     teamA: "Live",
     logoTeamA : 'gf',
     teamB: 'Man City', 
     logoTeamB: 'gm ',
     time:0,
     status:0,
     venue: "",
     goalTeamA: 0,
     goalTeamB: 0,
     isDeleted:false
}

  it("deploys", async function () {

    const DemoToken = await ethers.getContractFactory("DemoToken");
    const Factory = await ethers.getContractFactory("FactoryBet");
    console.log("Deploying SeedRound now, please wait ...");
    // instanceFactory = await SeedRound.deployed();
      instanceToken = await DemoToken.deploy( "Token", "TKN", totalSupply );
      instanceFactory = await Factory.deploy();
      await instanceFactory.initialize();
  });

  it("check Owner the Seed", async function () {
    const accounts = await ethers.getSigners();
    const owner = await instanceFactory.owner();
    console.log("owner: ", owner);
    expect(owner).to.equal( accounts[0].address);
    // assert.equal(owner, accounts[0], "Owner is not the first account");
  })

  it("check Token supply", async function () {
    const supply = await instanceToken.totalSupply();
    // assert.equal(supply.toString(), totalSupply.toString());
    expect(supply).to.equal(totalSupply);
  })

  it("Bet create", async function(){
    const accounts = await ethers.getSigners();
    await instanceFactory.createBet(bet);
  })

});
