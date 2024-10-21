// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract NoReceive {
    function getContractAddress() public view returns (address) {
        return address(this);
    }
}
