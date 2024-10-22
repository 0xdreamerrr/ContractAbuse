// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ContractFactory} from "../src/ContractFactory.sol";
import {Create2} from "../src/Create2.sol";

contract Create2Test is Test {
    Create2 internal create2;
    ContractFactory internal contractFactory;
    string ethUrl = vm.rpcUrl("ETH_mainnet");
    string arbUrl = vm.rpcUrl("ARB_URL");
    uint256 internal eth;
    uint256 internal arb;

    function setUp() public {
        eth = vm.createFork(ethUrl);
        arb = vm.createFork(arbUrl);
    }

    function test_EtheriumDeploy() public {
        vm.selectFork(eth);
        create2 = new Create2();
        contractFactory = new ContractFactory();

        vm.deal(address(0x1), 100 ether);
        vm.startPrank(address(0x1));  
        bytes32 salt = "0xdreamer";
        bytes memory creationCode = abi.encodePacked(type(ContractFactory).creationCode);

        address computedAddress = create2.computeAddress(salt, keccak256(creationCode));
        address deployedAddress = create2.deploy(salt , creationCode);
        vm.stopPrank();

        assertEq(computedAddress, deployedAddress); 
    }

    function test_ArbitrumDeploy() public {
        vm.selectFork(arb);
        create2 = new Create2();
        contractFactory = new ContractFactory();

        vm.deal(address(0x1), 100 ether);
        vm.startPrank(address(0x1));  
        bytes32 salt = "0xdreamer";
        bytes memory creationCode = abi.encodePacked(type(ContractFactory).creationCode);

        address computedAddress = create2.computeAddress(salt, keccak256(creationCode));
        address deployedAddress = create2.deploy(salt , creationCode);
        vm.stopPrank();

        assertEq(computedAddress, deployedAddress);
    }
}