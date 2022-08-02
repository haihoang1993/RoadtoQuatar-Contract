// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./Util.sol";

//
interface InterfaceFactory{
    function getBetInfo(address betAdrress) external view returns(BetObj memory);
    function getBetInfoById(uint256 id) external view returns(BetObj memory);
}