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

  let instanceToken, instanceFactory, instanceBet;
  let addrs;

  const totalSupply = ethers.utils.parseEther("6000000000");
  const tokenPerBnb = ethers.utils.parseEther("10000");
  const timeStart = Math.floor(Date.now() / 1000) + 86400;
  // set timeEnd to 2 days from now
  const timeEnd = Math.floor(Date.now() / 1000) + 172800;

  console.log("timeStart: ", timeStart);



  it("deploys", async function () {
    addrs = await ethers.getSigners();
    const DemoToken = await ethers.getContractFactory("DemoToken");
    const Factory = await ethers.getContractFactory("FactoryBet");
    console.log("Deploying SeedRound now, please wait ...");
    // instanceFactory = await SeedRound.deployed();
    instanceToken = await DemoToken.deploy("Token", "TKN", totalSupply);
    instanceFactory = await Factory.deploy();
    await instanceFactory.initialize();
    await instanceFactory.setToken(instanceToken.address);
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
        goalTeamB: 0,
        isDeleted:false
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
    // console.log(list);
    instanceBet=await ethers.getContractAt("Bet", list[0].addressBet);
    expect(data.length).to.equal(list.length);
  })

  it("Transfer token:", async function () {
      
      await instanceToken.transfer(addrs[1].address,ethers.utils.parseEther("50000"))
      await instanceToken.transfer(addrs[2].address,ethers.utils.parseEther("50000"))
      await instanceToken.transfer(addrs[3].address,ethers.utils.parseEther("50000"))
      await instanceToken.transfer(addrs[4].address,ethers.utils.parseEther("50000"))

      const approve = ethers.utils.parseEther("10000000");
       await instanceToken.connect(addrs[1]).approve(instanceBet.address, approve);
       await instanceToken.connect(addrs[2]).approve(instanceBet.address, approve);
       await instanceToken.connect(addrs[3]).approve(instanceBet.address, approve);
       await instanceToken.connect(addrs[4]).approve(instanceBet.address, approve);

      const amountToken = await instanceToken.balanceOf(addrs[0].address);
      const amountToken1 = await instanceToken.balanceOf(addrs[1].address);
      const amountToken2 = await instanceToken.balanceOf(addrs[2].address);
      // const amountToken2 = await instanceToken.balanceOf(addrs[3].address);
      console.log('token:', amountToken, amountToken1, amountToken2);
  })

  it("Bet Vote:", async function () {
    await instanceBet.connect(addrs[1]).startBet(ethers.utils.parseEther("10000"),2)
    await instanceBet.connect(addrs[2]).startBet(ethers.utils.parseEther("10000"),2)
    await instanceBet.connect(addrs[3]).startBet(ethers.utils.parseEther("20000"),3)
    await instanceBet.connect(addrs[4]).startBet(ethers.utils.parseEther("20000"),3)
  })

  it('getAllBet ', async function(){
    const data= await instanceBet.getAllBet();
    console.log(data);
    expect(data.length).to.equal(4)
  })
  it('get get address', async function(){
    const data= await instanceBet.getBetUser(addrs[1].address);
    console.log(data);
    expect(data.length).to.equal(1)
  })
  it('getRewardBet not done', async function(){
    const data= await instanceBet.getRewardBet(addrs[2].address);
    console.log(data);
    expect(data).to.equal(ethers.utils.parseEther("0"))
  })

  it('getRewardBet done', async function(){
    await instanceFactory.setStatus(instanceBet.address,2)
    const data= await instanceBet.getRewardBet(addrs[2].address);
    expect(data).to.equal(ethers.utils.parseEther("20000"))
  })
  it('getRewardBet user not exsit', async function(){
    await instanceFactory.setStatus(instanceBet.address,2)
    const data= await instanceBet.getRewardBet(addrs[5].address);
    expect(data).to.equal(ethers.utils.parseEther("0"))
  })
  it('get claim all done', async function(){
    await instanceFactory.setStatus(instanceBet.address,2)
    const data= await instanceBet.caculateClaimAll(addrs[2].address);
    expect(data).to.equal(ethers.utils.parseEther("30000"))
  })

  it('claim', async function(){
    await instanceFactory.setStatus(instanceBet.address,2)
    const data= await instanceBet.caculateClaimAll(addrs[2].address);
    await instanceBet.connect(addrs[2]).claimBet()
    const balanceOf = await instanceToken.balanceOf(addrs[2].address);
    expect(data).to.equal(ethers.utils.parseEther("30000"))
    expect(balanceOf).to.equal(ethers.utils.parseEther("70000"))
  })
  it('claim 2 test', async function(){
    // await instanceBet.connect(addrs[2]).claimBet()
    
  })

});
