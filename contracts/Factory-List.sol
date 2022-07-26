// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./InterfaceFactory.sol";
import "./Bet.sol";

contract FactoryList is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public tokenEco;
    BetObj[] public dataFactories;

    constructor() {
         
    }
    
    function checkSort(
        BetObj memory item1,
        BetObj memory item2,
        bool isDesc
    ) public pure returns (bool) {
        bool check =  item1.time  < item2.time;
        if (isDesc) {
            return check;
        } else {
            return !check;
        }
    }


    function sortList(
        BetObj[] memory list,
        bool isDesc
    ) private pure returns (BetObj[] memory) {
        uint256 l = list.length;
        for (uint256 i = 0; i < l; i++) {
            for (uint256 j = i + 1; j < l; j++) {
                bool check = checkSort(list[i], list[j], isDesc);
                if (check) {
                    BetObj memory temp = list[i];
                    list[i] = list[j];
                    list[j] = temp;
                }
            }
        }

        return list;
    }

     function checkFilter(uint256 typeFilter, BetObj memory data)
        private
        view
        returns (bool)
    {
        return
            (typeFilter == 1 && data.status==Status.ComingSoon) ||
            (typeFilter == 2 && data.status==Status.Playing) ||
            (typeFilter == 3 && data.status==Status.Finished);
    }

     function filterSortList(BetObj[] memory _dataFactories, uint256 typeFilter)
        public
        view
        returns (BetObj[] memory)
    {
        BetObj[] memory list = new BetObj[](_dataFactories.length);

        uint256 size = 0;
        if (typeFilter == 0) {
            list = _dataFactories;
        } else {
            for (uint256 index = 0; index < _dataFactories.length; index++) {
                if (checkFilter(typeFilter, _dataFactories[index])) {
                    list[size] = _dataFactories[index];
                    size++;
                }
            }
            BetObj[] memory listTemp = new BetObj[](size);
            for (uint256 i = 0; i < size; i++) {
                listTemp[i] = list[i];
            }
            return sortList( listTemp, false);
        }

        return sortList(list, false);
    }

      function sliceArray(
        BetObj[] memory list,
        uint256 start,
        uint256 end
    ) external pure returns (BetObj[] memory) {
        if (end >= list.length) {
            end = list.length;
        }
        BetObj[] memory result = new BetObj[](end - start);

        if (start >= list.length) {
            return new BetObj[](0);
        }
        for (uint256 index = start; index < end; index++) {
            result[index - start] = list[index];
        }
        return result;
    }

}