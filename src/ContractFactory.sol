// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "./ContractWithNoReceive.sol";
import "./DepositContract.sol";

contract ContractFactory {
    address public depositContractAddress;

    constructor() {
        createDepositContract();
    }

    function createDepositContract() public returns (address) {
        DepositContract newDepositContract = new DepositContract();
        depositContractAddress = address(newDepositContract);
        return depositContractAddress;
    }

}
