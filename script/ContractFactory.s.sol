// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import {Script, console} from "forge-std/Script.sol";
import {ContractFactory} from "../src/ContractFactory.sol";
import {Create2} from "../src/Create2.sol";

contract ContractDeploy is Script {
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

    function run() public {
        vm.selectFork(eth);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        bytes memory creationCode = abi.encodePacked(type(ContractFactory).creationCode);
        bytes32 salt = "0xdreamerrr";
        address addr;

        vm.startBroadcast(deployerPrivateKey);
        assembly {
            addr := create2(callvalue(), add(creationCode, 0x20), mload(creationCode), salt)
        }

        if (addr == address(0)) {
            revert();
        } 
        vm.stopBroadcast();
        console.log("Contract deployed on Etherium at:", addr);

        vm.selectFork(arb);
        vm.startBroadcast(deployerPrivateKey);
        assembly {
            addr := create2(callvalue(), add(creationCode, 0x20), mload(creationCode), salt)
        }

        if (addr == address(0)) {
            revert();
        } 
        vm.stopBroadcast();
        console.log("Contract deployed on Arbitrum at:", addr);
    }
}