const BN = require('bn.js')
const { ethers, upgrades } = require('hardhat');
const { expect } = require('chai');
const data = require('../live.json');
/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
describe("FactoryBetList", function () {

  let instanceToken, instanceFactory;
  const totalSupply = ethers.utils.parseEther("1000000");
  const tokenPerBnb = ethers.utils.parseEther("10000");
  const timeStart = Math.floor(Date.now() / 1000) + 86400;
  // set timeEnd to 2 days from now
  const timeEnd = Math.floor(Date.now() / 1000) + 172800;

  console.log("timeStart: ", timeStart);



  it("deploys", async function () {

    const DemoToken = await ethers.getContractFactory("DemoToken");
    const Factory = await ethers.getContractFactory("FactoryBet");
    console.log("Deploying SeedRound now, please wait ...");
    // instanceFactory = await SeedRound.deployed();
    instanceToken = await DemoToken.deploy("Token", "TKN", totalSupply);
    instanceFactory = await Factory.deploy();
    await instanceFactory.initialize();
  });

  it("add list:", async function () {
    const [owner] = await ethers.getSigners();

    for (let i = 0; i < data.length; i++) {
      const e = data[i]

      const { home_team, away_team } = e;

      const bet = {
        id: 0,
        addressBet: "0x0000000000000000000000000000000000001000",
        teamA: home_team.team_name,
        logoTeamA: home_team.team_id+"",
        teamB: away_team.team_name,
        logoTeamB: away_team.team_id+"",
        time: e.event_timestamp,
        status: 0,
        venue: e.venue,
        goalTeamA: 0,
        goalTeamB: 0
      }

      try {
        await instanceFactory.connect(owner).createBet(bet)

      } catch (error) {
        console.log(error)
      }

    }


  })
  it("check list:", async function () {
    const [list,total] = await instanceFactory.getListBet(0, 1, 30)
    console.log(list);
    expect(data.length).to.equal(list.length);
  })

});
