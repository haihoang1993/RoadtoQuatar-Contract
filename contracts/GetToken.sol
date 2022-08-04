// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract GetToken {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    IERC20 public token;
    uint256 public amoutToken;
    address owner;
    
    constructor(address _token){
        token=IERC20(_token);
        amoutToken = 100_000 * (10 ** uint256(18));
        owner=msg.sender;
    }

    function initToken(address _token) public onlyOwner{
        token=IERC20(_token);
    }
    
    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }
  
    function getToken() external {
        require(token.balanceOf(msg.sender)<100* (10 ** uint256(18)));
        token.safeTransfer(msg.sender,amoutToken);
    }
}