// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./InterfaceFactory.sol";
import "./Bet.sol";
import './Factory-List.sol';
contract FactoryBet is Ownable,FactoryList, InterfaceFactory {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    mapping(address => BetObj) bets;

    constructor() {
         
    }

    function createBet(BetObj memory _bet) external {
        Bet _newBet =new Bet();
        _bet.addressBet = address(_newBet);
        dataFactories.push(_bet);      
        bets[address(_newBet)]=_bet;
    } 

     function getBetInfo(address betAdrress) external  view override returns(BetObj memory) {
        return bets[betAdrress];
     }

}