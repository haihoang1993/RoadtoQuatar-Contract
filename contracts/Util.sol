    // SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;


    enum Status{ ComingSoon, Playing,  Finished }
    enum Result { TeamA, Equal, TeamB }
 
    struct BetObj{
         address addressBet;
         string teamA;
         string teamB;
         uint256 time;   
         Status status;
         Result result;
    }
