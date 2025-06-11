// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "hardhat/console.sol";

contract Voting {
    // 一个mapping来存储候选人的得票数
    // 一个vote函数，允许用户投票给某个候选人
    // 一个getVotes函数，返回某个候选人的得票数
    // 一个resetVotes函数，重置所有候选人的得票数
    mapping(address => uint) votesMap;

    // Add the library methods
    using EnumerableSet for EnumerableSet.AddressSet;

    // Declare a set state variable
    EnumerableSet.AddressSet private votesSet;

    // uint256[7] _int = [1, 5, 10, 50, 100, 500, 1000];

    // string[7] _roman = ["I", "V", "X", "L", "C", "D", "M"];

    constructor() {}

    // 投票
    function vote(address candidate, uint voteVal) public {
        votesMap[candidate] += voteVal;
        votesSet.add(candidate);
    }

    // 获取票数
    function getVotes(address candidate) public view returns (uint) {
        return votesMap[candidate];
    }

    // 一个resetVotes函数，重置所有候选人的得票数
    modifier onlyOwner(address owner) {
        require(owner == msg.sender, "Ownable:caller is not the owner");
        _;
    }

    function resetVotes(address owner) public onlyOwner(owner) {
        // 只有部署人才能 重置票数
        // require(owner == msg.sender, "Ownable:caller is not the owner");
        address[] memory addrArray = votesSet.values();
        // 遍历
        for (uint256 i = 0; i < addrArray.length; i++) {
            address addr = addrArray[i];
            // 使用console.log打印地址，仅在测试或本地环境中有效
            votesMap[addr] = 0;
        }
    }

    //  反转字符串 (Reverse String)
    function ReverseStr(string memory str) public pure returns (string memory) {
        bytes memory b = bytes(str);
        uint len = b.length;
        // console.log("len==========", len);
        bytes memory result = new bytes(len);
        for (uint i = 0; i < len; i++) {
            result[i] = b[len - 1 - i];
        }
        return string(result);
    }

    // 罗马数字转整数
    mapping(string => uint) romanValues;

    function romanToInt(string memory roman) public returns (uint) {
        // 创建映射来存储罗马数字符号及其对应的值
        romanValues["I"] = 1;
        romanValues["V"] = 5;
        romanValues["X"] = 10;
        romanValues["L"] = 50;
        romanValues["C"] = 100;
        romanValues["D"] = 500;
        romanValues["M"] = 1000;

        // // 处理特殊情况，例如IV（4）和IX（9）等
        uint total = 0;
        uint prevValue = 0;
        bytes memory _roman = bytes(roman);
        for (uint i = 0; i < _roman.length; i++) {
            // 将 bytes1 提升为 bytes
            bytes memory bytesData = new bytes(1);
            bytesData[0] = _roman[i];
            // 将 bytes 转换为 string
            string memory currentChar = string(bytesData);

            if (romanValues[currentChar] > prevValue) {
                total += romanValues[currentChar] - 2 * prevValue; // 减去之前值的两倍以处理如IV的情况
            } else {
                total += romanValues[currentChar];
            }
            prevValue = romanValues[currentChar];
        }
        console.log(total);
        return total;
    }

    uint[] values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    string[] symbols = [
        "M",
        "CM",
        "D",
        "CD",
        "C",
        "XC",
        "L",
        "XL",
        "X",
        "IX",
        "V",
        "IV",
        "I"
    ];

    // 整数转罗马数
    function intToRoman(uint num) public returns (string memory) {
        string memory roman = "";
        for (uint i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                num -= values[i];
                roman = string(abi.encodePacked(roman, symbols[i]));
            }
        }
        console.log(roman);
        return roman;
    }

    // 合并2个有序的数组
    function mergeSortedArrays(
        uint[] memory arr1,
        uint[] memory arr2
    ) public pure returns (uint[] memory mergedArr) {
        // 计算合并后数组的长度
        uint len1 = arr1.length;
        uint len2 = arr2.length;
        uint mergedLen = len1 + len2;

        // 创建合并后的数组
        uint[] memory result = new uint[](mergedLen);

        // 初始化指针
        uint i = 0; // 指向arr1的指针
        uint j = 0; // 指向arr2的指针
        uint k = 0; // 指向result的指针

        // 合并两个数组
        while (i < len1 && j < len2) {
            if (arr1[i] <= arr2[j]) {
                result[k++] = arr1[i++];
            } else {
                result[k++] = arr2[j++];
            }
        }

        // 处理剩余的元素（如果有）
        while (i < len1) {
            result[k++] = arr1[i++];
        }
        while (j < len2) {
            result[k++] = arr2[j++];
        }

        return result;
    }

    // 二分查找
    function binarySearch(
        uint[] memory arr,
        uint value
    ) public pure returns (int) {
        uint left = 0;
        uint right = arr.length - 1;
        while (left <= right) {
            uint mid = left + (right - left) / 2;
            if (arr[mid] == value) {
                return int(mid); // 返回找到值的索引
            } else if (arr[mid] < value) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1; // 如果没有找到，则返回-1
    }
}
