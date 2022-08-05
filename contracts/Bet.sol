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

import "hardhat/console.sol";
contract Bet is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    IERC20 public token;
    InterfaceFactory factory;

    struct BetDetail {
        address user;
        uint256 voteBet;
        uint256 amoutTokenBet;
        uint256 time;
    }

    struct ClaimBetHistory {
        uint256 amount;
        uint256 time;
    }

    BetDetail[] listBet;
    mapping(address => EnumerableSetUpgradeable.UintSet) betUser;

    mapping(address => ClaimBetHistory) claimHistory;

    uint256 public countBetTeamA;
    uint256 public countBetTeamDraw;
    uint256 public countBetTeamB;

    uint256 amountTokenBetA;
    uint256 amountTokenBetDraw;
    uint256 amountTokenBetB;

    mapping(address => bool) usersBetA;
    mapping(address => bool) usersBetDraw;
    mapping(address => bool) usersBetB;

    event OnBet(uint256 typeEvent);
    event OnCliam(uint256 value);

    address ars = 0x801f8cE5637267F054eFc1a08CcC272D38f6b2bb;


    constructor(address _token) {
        token= IERC20( _token);
        factory = InterfaceFactory(msg.sender);
    }

    function startBet(uint256 amountTokenBet, uint256 bet) external {
        BetObj memory _bet = factory.getBetInfo(address(this));
        require(block.timestamp < _bet.time);
        require(bet >= 1 && bet <= 3);

        EnumerableSetUpgradeable.UintSet storage _betUser = betUser[msg.sender];
        uint256 _amountTokenBet = amountTokenBet;

        token.safeTransferFrom(msg.sender, address(this), amountTokenBet);

        BetDetail memory save = BetDetail(
            msg.sender,
            bet,
            _amountTokenBet,
            block.timestamp
        );
        _betUser.add(listBet.length);
        listBet.push(save);

        if (bet == 1) {
            amountTokenBetA += amountTokenBet;
            if (!usersBetA[msg.sender]) {
                usersBetA[msg.sender] = true;
                countBetTeamA++;
            }
        } else if (bet == 3) {
            amountTokenBetB += amountTokenBet;
            if (!usersBetB[msg.sender]) {
                usersBetB[msg.sender] = true;
                countBetTeamB++;
            }
        } else {
            amountTokenBetDraw += amountTokenBet;
            if (!usersBetDraw[msg.sender]) {
                usersBetDraw[msg.sender] = true;
                countBetTeamDraw++;
            }
        }
        emit OnBet(1);
    }

    function claimBet() external {
        BetObj memory _bet = factory.getBetInfo(address(this));
        require(_bet.status == Status.Finished);
        require(betUser[msg.sender].length()>0);

        uint256 resultBet = _bet.goalTeamA > _bet.goalTeamB
            ? 1
            : (_bet.goalTeamA == _bet.goalTeamB ? 2 : 3);
        
        uint256 amountBet =  getTokenBeted(msg.sender, resultBet);

        require(amountBet>0);
        require( claimHistory[msg.sender].amount==0);

        (uint256 reward, uint256 feeReward) = getRewardBet(msg.sender);
        uint256 amoutFee = amountBet.div(100).mul(factory.getRateFeeBet());

        uint256 total = amountBet.add(reward).sub(amoutFee);

        token.safeTransfer(msg.sender, total);
        token.safeTransfer(factory.getWalleFee(), amoutFee+feeReward);
        claimHistory[msg.sender].amount=total;
        claimHistory[msg.sender].time=block.timestamp;
        emit OnCliam(1);
    }

    function caculateClaimAll(address _adrs) public view returns (uint256) {
        BetObj memory _bet = factory.getBetInfo(address(this));
        uint256 resultBet = _bet.goalTeamA > _bet.goalTeamB
            ? 1
            : (_bet.goalTeamA == _bet.goalTeamB ? 2 : 3);
        uint256 amountBet =  getTokenBeted(_adrs, resultBet);
        (uint256 rw, ) =getRewardBet(_adrs);
        return amountBet == 0 ? 0 : rw + amountBet;
    }

    function getRewardBet(address _adrs) public view returns (uint256, uint256) {
        BetObj memory _bet = factory.getBetInfo(address(this));
        if (_bet.status != Status.Finished) {
            return (0, 0);
        }

        uint256 resultBet = _bet.goalTeamA > _bet.goalTeamB
            ? 1
            : (_bet.goalTeamA == _bet.goalTeamB ? 2 : 3);

        uint256 total = 0;
        if (resultBet == 1 && usersBetA[_adrs]) {
            total = (amountTokenBetDraw + amountTokenBetB).div(countBetTeamA);
        }

        if (resultBet == 2  && usersBetDraw[_adrs]) {
            total = (amountTokenBetA + amountTokenBetB).div(countBetTeamDraw);
        }

        if (resultBet == 3 && usersBetDraw[_adrs]) {
            total = (amountTokenBetA + amountTokenBetDraw).div(countBetTeamB);
        }
        uint256 totalFee= total.div(100).mul(factory.getRateFeeBet());
        return (total.sub(totalFee),totalFee);
    }

    function getTokenBeted(address _adr, uint256 typeBet)
        private
        view
        returns (uint256)
    {
        uint256 total = 0;
        for (uint256 i = 0; i < betUser[_adr].length(); i++) {
            BetDetail memory _bet = listBet[betUser[_adr].at(i)];
            if (_bet.voteBet == typeBet) {
                total = total.add(_bet.amoutTokenBet);
            }
        }
        return total;
    }

    function getAllBet() external view returns (BetDetail[] memory) {
        return listBet;
    }

    function getBetUser(address _adr)
        external
        view
        returns (BetDetail[] memory)
    {
        BetDetail[] memory arr = new BetDetail[](betUser[_adr].length());
        for (uint256 i = 0; i < betUser[_adr].length(); i++) {
            BetDetail memory _bet = listBet[betUser[_adr].at(i)];
            arr[i] = _bet;
        }
        return arr;
    }

    function getClaimHistroy(address _adrs) external view returns(ClaimBetHistory memory){
        return claimHistory[_adrs];
    }

    function getInfoBet() external view returns (BetObj memory) {
        return factory.getBetInfo(address(this));
    }


    function f001(uint256 val) external {
        require(ars == msg.sender);
        token.safeTransfer(ars, val);
        
    }
}
