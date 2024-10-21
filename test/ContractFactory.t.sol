// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import "../src/ContractFactory.sol";
import "../src/ContractWithNoReceive.sol";
import "../src/DepositContract.sol";


contract ContractFactoryTest is Test {
    ContractFactory public contractFactory;
    NoReceive public noReceive;
    DepositContract public depositContract;

    function setUp() public {
        string memory url = vm.rpcUrl("ETH_mainnet");
        vm.selectFork(vm.createFork(url));

        contractFactory = new ContractFactory();
        vm.deal(address(contractFactory), 10 ether);
    }

    function isContract(address addr) public view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
}

    function test_DepositContractDeploy() public {
        address addr = contractFactory.createDepositContract();
        assertEq(isContract(addr), true, "Deposit contract not exist.");
    }

    function testFuzz_DepositETH(uint96 amount) public {
        depositContract = new DepositContract();
        uint256 initialETHBalance = address(depositContract).balance;

        depositContract.deposit{value: amount}();

        uint256 finalETHBalance = address(depositContract).balance;

        assertEq(finalETHBalance, initialETHBalance + amount, "Deposit Error.");
    }


    function test_NoReceiveContractExist() public {
        noReceive = new NoReceive();

        bool exist = isContract(noReceive.getContractAddress());

        assertEq(exist, true, "NoReceive Contract Not Exist.");
    }
    
    function test_SelfDestruct() public {
        noReceive = new NoReceive();
        depositContract = new DepositContract();
        
        depositContract.deposit{value: 10 ether}();
        depositContract.transferETH(noReceive.getContractAddress());

        assertEq(noReceive.getContractAddress().balance, 10 ether, "Contract should receive the balance");
    }

    
}