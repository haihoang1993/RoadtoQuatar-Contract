// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "./InterfaceFactory.sol";
import "./Bet.sol";
import './Factory-List.sol';

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

contract FactoryBet is FactoryList, InterfaceFactory,  
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable {
    using SafeERC20 for IERC20;
    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    IERC20 public token;

    mapping(address => BetObj) bets;
    mapping(uint256 => BetObj) betsID;

    uint256 public num;

    uint256 private idAuto = 0;

    function initialize(address _token)
        public
        initializer
    {
        token=IERC20(_token);
        __Ownable_init();
        __UUPSUpgradeable_init();
        _transferOwnership(msg.sender);
    }

     function _authorizeUpgrade(address) internal override onlyOwner {}


    function createBet(BetObj memory _bet) external onlyOwner {
        Bet _newBet =new Bet(address(token));
        _bet.id=idAuto;
        _bet.addressBet = address(_newBet);
        dataFactories.push(_bet);      
        bets[address(_newBet)]=_bet;
        betsID[idAuto]=_bet;
        idAuto++;
    } 

    function setStatus(address _bet, uint typeStatus) external onlyOwner{
        require(typeStatus>=0 && typeStatus<=2);
        bets[_bet].status=Status(typeStatus);
        betsID[bets[_bet].id].status=Status(typeStatus);
        dataFactories[bets[_bet].id].status=Status(typeStatus);
    }

     function getBetInfo(address betAdrress) external  view override returns(BetObj memory) {
        return bets[betAdrress];
     }

     function getBetInfoById(uint256 id) external  view override returns(BetObj memory) {
        return betsID[id];
     }

     function setTest(uint256 _num) external {
         num=_num;
     }



}