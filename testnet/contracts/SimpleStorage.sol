// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedData;
    event DataStored(uint256 newValue);

    // 存储数据
    function store(uint256 x) public {
        storedData = x;
        emit DataStored(x);
    }

    // 读取数据
    function retrieve() public view returns (uint256) {
        return storedData;
    }
} 