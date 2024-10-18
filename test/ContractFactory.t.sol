// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import "../src/ContractFactory.sol";

contract ContractFactoryTest is Test {
    ContractFactory public contractFactory;

    function setUp() public {
        string memory url = vm.rpcUrl("ETH_mainnet");
        vm.selectFork(vm.createFork(url));

        contractFactory = new ContractFactory();
        vm.deal(address(contractFactory), 10 ether);
    }

    function testFuzz_DepositETH(uint96 amount) public {
        uint256 initialETHBalance = address(contractFactory).balance;

        contractFactory.deposit{value: amount}();

        uint256 finalETHBalance = address(contractFactory).balance;

        assertEq(finalETHBalance, initialETHBalance + amount, "Deposit Error.");
    }


    function test_NoReceiveContractExist() public view {
        address noReceiveAddress = contractFactory.getAddress();

        bool exist = contractFactory.isContract(noReceiveAddress);

        assertEq(exist, true, "Contract Not Exist.");
    }
    
    function test_SelfDestruct() public {
        address noReceiveAddress = contractFactory.getAddress();
        contractFactory.transferETHtoContract(noReceiveAddress);

        assertEq(noReceiveAddress.balance, 10 ether, "Contract should receive the balance");
    }

}