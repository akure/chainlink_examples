// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;
import "forge-std/Script.sol";
import {DataConsumerV3} from "src/BTCUSDPrice.sol";
contract ChainlinkScript is Script {
    function setUp() public {}
    function run() public {
        vm.startBroadcast();
        DataConsumerV3 prices = new DataConsumerV3();
        vm.stopBroadcast();
    }
}
