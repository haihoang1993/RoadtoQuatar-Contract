    // SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;


    enum Status{ ComingSoon, Playing,  Finished }
 
    struct BetObj{
         address addressBet;
         string teamA;
         string logoTeamA;
         string teamB;
         string logoTeamB;
         uint256 time;   
         Status status;
         uint256 goalTeamA;
         uint256 goalTeamB;
    }
