// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "./ContractWithNoReceive.sol";

contract ContractFactory {
    NoReceive[] public noReceive;

    constructor() {
        createNoReceiveContract();
    }

    function createNoReceiveContract() private {
        NoReceive newNoReceive = new NoReceive();
        noReceive.push(newNoReceive);
    }

    function deposit() public payable {}

    function transferETHtoContract(address contractAddress) public {
        require(isContract(contractAddress), "ContractFactory: Address not exist");
        selfdestruct(payable(contractAddress));
    }

    function getAddress() public view returns (address) {
        return address(noReceive[0]);
    }

    function isContract(address addr) view public returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }

}
