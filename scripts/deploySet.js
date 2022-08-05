const hre = require("hardhat");
const ethers = hre.ethers;
const contractDeployed = require('../deployednain.json')
const data = require('../live.json');



async function main() {
  const Factory = await ethers.getContractFactory("FactoryBet");
  const factory = await Factory.attach(contractDeployed.factory);

  const owner = await factory.owner();
  const token = await factory.token();

  console.log('address', owner);
  console.log('token', token);

  const [list,total] = await factory.getListBet(0, 1, 30)
    console.log(list);


  async function setToken() {
    await factory.setToken(contractDeployed.token);
  }

  // await setToken();


  async function addBet() {
    const bet = dataCreate()
    try {
      await factory.createBetNew(bet)
    } catch (error) {
      console.log(error)
    }
  }

  // await addBet();


  async function statusBet() {
    await factory.setStatus('0xfEfeeDAc15232397f34Ba0Ea32d5372BeFb3Ef1b', 2)

  }



}

function dataCreate() {
  const e = data[0]

  const { home_team, away_team } = e;

  const bet = {
    id: 0,
    addressBet: "0x0000000000000000000000000000000000001000",
    teamA: home_team.team_name,
    logoTeamA: home_team.team_id + "",
    teamB: away_team.team_name,
    logoTeamB: away_team.team_id + "",
    time: e.event_timestamp,
    status: 0,
    venue: e.venue,
    goalTeamA: 0,
    goalTeamB: 0,
    isDeleted: false,
  }
  return bet;
}



main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });