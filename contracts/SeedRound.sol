// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Utils.sol";

contract SeedRound is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public tokenEco;

    uint256 public tokensPerBnb;

    uint256 public timeStart;
    uint256 public timeEnd;

    uint256 public timeLock = 60 * 60 * 24 * 180;

    // Contributions state
    mapping(address => uint256) public contributions;

    mapping(address => Data) public data;

    // Total wei raised (BNB)
    uint256 public weiRaised;

    uint256 public percentTokenFirst = 10;
    uint256 public timePeriod = 60 * 60 * 24 * 180;

    // 12 moth
    uint256 public countPeriodWithdraw = 12;

    uint256 public timeFinishPool;

    struct Data {
        uint256 amountToken;
        uint256 timecContribute;
        uint256 amountWithdrawed;
        uint256 lastWithdrawed;
        uint256 countWithdrawed;
        uint256 amountCaculateFirst;
        bool isFirstWithdrawed;
    }

    //
    constructor(address _tokenEco, uint256 _tokensPerBnb) {
        tokenEco = IERC20(_tokenEco);
        tokensPerBnb = _tokensPerBnb;
    }

    function claim() public {}

    function contribute() public payable {
        // Validations.
        require(
            msg.sender != address(0),
            "Presle: beneficiary is the zero address"
        );

        require(isOpen() == true, "Crowdsale has not yet started");

        _contribute(msg.sender, msg.value);
    }

    // Calculate how many MANYs do they get given the amount of wei
    function _getTokenAmount(uint256 weiAmount) public view returns (uint256) {
        return weiAmount.mul(tokensPerBnb);
    }

    function withdrawToken() public {

    }

    function _contribute(address beneficiary, uint256 weiAmount) internal {
        // Update how much wei we have raised
        weiRaised = weiRaised.add(weiAmount);
        // Update how much wei has this address contributed
        contributions[beneficiary] = contributions[beneficiary].add(weiAmount);

        uint256 tokenAmount = _getTokenAmount(weiAmount);
        Data memory _dataBuy = data[beneficiary];
        _dataBuy.amountToken = _dataBuy.amountToken.add(tokenAmount);
        _dataBuy.timecContribute = block.timestamp;
        _dataBuy.amountWithdrawed = 0;
        _dataBuy.lastWithdrawed = 0;
        _dataBuy.countWithdrawed = 0;
        _dataBuy.amountCaculateFirst= tokenAmount.mul(percentTokenFirst).div(100);
        data[beneficiary] = _dataBuy;
    }

     function _caculateWithdraw(address _address)
        private
        view
        returns (uint256 amountTokenWithdraw, uint256 countWithdrawedSave)
    {
        Data memory _dataBuy = data[_address];
        uint256 _amountTokenWithdraw = _dataBuy.isFirstWithdrawed ? 0 : data[_address].amountCaculateFirst;

        uint256 calCountTime = (timeFinishPool + timeLock) < block.timestamp ? (block.timestamp - (timeFinishPool + timeLock)).div(timePeriod) : 0;
        calCountTime = calCountTime > countPeriodWithdraw ? countPeriodWithdraw : calCountTime;
        uint256 countWithdraw = calCountTime > _dataBuy.countWithdrawed ? calCountTime - _dataBuy.countWithdrawed : 0;
        
        return (_amountTokenWithdraw, 0);
    }

    // funcitons isOpnen returns a bool by timeStart and timeEnd
    function isOpen() public view returns (bool) {
        return block.timestamp > timeStart && block.timestamp < timeEnd;
    }

    // funcitons setTime sets timeStart and timeEnd
    function setTime(uint256 _timeStart, uint256 _timeEnd) public onlyOwner {
        timeStart = _timeStart;
        timeEnd = _timeEnd;
    }
}
