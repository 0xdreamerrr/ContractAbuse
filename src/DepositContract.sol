// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract DepositContract {
    function deposit() public payable {}

    function transferETH(address receiverAddress) public {
        require(receiverAddress != address(0), "DepositContract: Address should be not zero.");
        selfdestruct(payable(receiverAddress));
    }
}