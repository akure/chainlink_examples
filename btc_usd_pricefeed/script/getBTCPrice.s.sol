// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import {DataConsumerV3} from "src/BTCUSDPrice.sol";

contract InteractWithDataFeed is Script {
    function run() external {
        address deployedContractAddress = 0x81F0efC05089064C5eF2B596Cf72cdb67F4a9D4a; // Replace with actual contract address, if you have.
        DataConsumerV3 dataFeed = DataConsumerV3(deployedContractAddress);

        int256 latestPrice = dataFeed.getChainlinkDataFeedLatestAnswer();
        console.log("The latest BTC/USD price is:", latestPrice);
    }
}

