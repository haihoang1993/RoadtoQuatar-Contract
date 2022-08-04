const hre = require("hardhat");
const ethers = hre.ethers;
const contractDeployed = require('../deployed.json')
const data = require('../live.json');



async function main() {
    const Factory = await ethers.getContractFactory("FactoryBet");
    const factory= await Factory.attach(contractDeployed.factory);
    // await factory.setToken(contractDeployed.token);
    for (let i = 0; i < 1; i++) {
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
          isDeleted:false,
        }
  
        try {
          await factory.createBet(bet)
        } catch (error) {
          console.log(error)
        }
  
      }

}



main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });