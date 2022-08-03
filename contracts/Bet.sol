// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./InterfaceFactory.sol";
import "./Util.sol";

contract Bet is Ownable {
   using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    IERC20 public token;
    InterfaceFactory factory;

    struct BetDetail {
        address user;
        uint voteBet;
        uint256 amoutTokenBet;
        uint256 time;
     }

     BetDetail[] listBet;
     mapping (address => EnumerableSetUpgradeable.UintSet) betUser;

     uint256 public countBetTeamA;
     uint256 public countBetTeamDraw;
     uint256 public countBetTeamB;

     uint256 amountTokenBetA;
     uint256 amountTokenBetDraw;
     uint256 amountTokenBetB;

     mapping(address => bool) usersBetA;
     mapping(address => bool) usersBetDraw;
     mapping(address => bool) usersBetB;


    constructor() {
         factory = InterfaceFactory(msg.sender);
    }

    function startBet(uint256 amountTokenBet, uint bet ) external {
        BetObj memory _bet= factory.getBetInfo(address(this));
        require(block.timestamp<_bet.time);
        require(bet>=1 && bet <=3);

        EnumerableSetUpgradeable.UintSet storage _betUser = betUser[msg.sender];
        uint256 _amountTokenBet= amountTokenBet;

        token.safeTransferFrom(msg.sender, address(this) , amountTokenBet);
        BetDetail memory save = BetDetail(msg.sender, bet,_amountTokenBet, block.timestamp) ;
        _betUser.add(listBet.length);
        listBet.push(save);

       if(bet==1) {
           amountTokenBetA+=amountTokenBet;
           if(!usersBetA[msg.sender]){
               usersBetA[msg.sender]=true;
               countBetTeamA++;
           }
             
       } else if(bet==3) {
           amountTokenBetB+=amountTokenBet;
           if(!usersBetB[msg.sender]){
               usersBetB[msg.sender]=true;
               countBetTeamB++;
           }
       }  else {
           amountTokenBetDraw+=amountTokenBet;
            if(!usersBetDraw[msg.sender]){
               usersBetDraw[msg.sender]=true;
               countBetTeamDraw++;
           }
       }
    
    }

    function cliamBet() public {

    }

    function getTokenRewardBet() external view returns(uint256) {
        BetObj memory _bet= factory.getBetInfo(address(this));
        if(_bet.status!=Status.Finished) {
            return 0;
        }

        uint resultBet = _bet.goalTeamA > _bet.goalTeamB ? 1 : (_bet.goalTeamA==_bet.goalTeamB?2 : 3);

        if(resultBet==1){
            return (amountTokenBetDraw + amountTokenBetB).div(countBetTeamA);
        } 

        if(resultBet==2){
            return (amountTokenBetA + amountTokenBetB).div(countBetTeamDraw);
        }

         if(resultBet==3){
            return (amountTokenBetA + amountTokenBetDraw).div(countBetTeamB);
        }
    }

    function getTokenBeted(address _adr, uint typeBet) private view returns(uint256) {
        uint256 total=0;
        for(uint256 i=0; i<betUser[_adr].length();i++){
            BetDetail memory _bet = listBet[betUser[_adr].at(i)];
            if(_bet.voteBet==typeBet){
                total=total.add(_bet.amoutTokenBet);
            }
        }
        return total;
    }

    function getAllBet() external view returns(BetDetail[] memory){
        return listBet;
    }

    function getBetUser(address _adr) external view returns (BetDetail[] memory){
         BetDetail[] memory arr = new BetDetail[](3);
         for(uint256 i=0; i<betUser[_adr].length();i++){
            BetDetail memory _bet = listBet[betUser[_adr].at(i)];
            arr[i]=_bet;
        }
        return arr;
    }
}