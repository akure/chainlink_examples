# Chainlink BTC/USD Price Feed on Sepolia Testnet

This guide walks you through deploying a Solidity smart contract that interacts with Chainlink data feeds to retrieve the latest BTC/USD price on the Sepolia testnet.

## Pre-requisit 
Fountry has to be installed properly.  And you should create a default directory structure with `forge init`  command, which will give below directory structure with related
fountry lib files as well. 
.
├── foundry.toml
├── lib
├── README.md
├── script
├── src
└── test



## Step 1: Create the Smart Contract

1. **Create the Contract File**:  
   First, navigate to your project directory and create the following Solidity file at `src/BTCUSDPrice.sol`:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.21;

   import "./chainlinkInterface.sol";

   contract DataConsumerV3 {
       AggregatorV3Interface internal dataFeed;

       /**
        * Network: Sepolia
        * Aggregator: BTC/USD
        * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        */
       constructor() {
           dataFeed = AggregatorV3Interface(
               0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
           );
       }

       function getChainlinkDataFeedLatestAnswer() public view returns (int) {
           (
               int answer,
           ) = dataFeed.latestRoundData();
           return answer;
       }
   }
   ```

   This contract fetches the latest BTC/USD price from Chainlink's data feed on the Sepolia testnet.

2. **Create the Chainlink Interface**:  
   Create the Chainlink interface at `src/chainlinkInterface.sol`:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.21;

   interface AggregatorV3Interface {
       function decimals() external view returns (uint8);
       function description() external view returns (string memory);
       function version() external view returns (uint256);

       function getRoundData(uint80 _roundId)
           external
           view
           returns (
               uint80 roundId,
               int256 answer,
               uint256 startedAt,
               uint256 updatedAt,
               uint80 answeredInRound
           );

       function latestRoundData()
           external
           view
           returns (
               uint80 roundId,
               int256 answer,
               uint256 startedAt,
               uint256 updatedAt,
               uint80 answeredInRound
           );
   }
   ```

## Step 2: Create a Deployment Script

1. **Create the Script File**:  
   Create a new script at `script/BTCUSDFeedsScript.s.sol`:

   ```solidity
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
   ```

## Step 3: Deploy the Contract

1. **Source the Environment Variables**:
   In your terminal, run:
   ```bash
   source .env

```
ETHEREUM_SEPOLIA_RPC_URL=Your_RPC
PRIVATE_KEY=YOUR_PRIVATE_KEY
ETHERSCAN_KEY=YOUR_ETHERSCAN_KEY
```

2. **Deploy the Contract**:
   Use the following command to deploy the contract:
   ```bash
   forge script script/BTCUSDFeedsScript.s.sol:ChainlinkScript --rpc-url $ETHEREUM_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --slow
   ```

   This command compiles the contract and broadcasts the deployment transaction to the Sepolia testnet.

## Step 4: Interact with the Deployed Contract

### Option 1: Using `cast`

1. **Get the Deployed Contract Address**:
   After deployment, take note of the contract address from the output.

2. **Call the Method**:
   Use the `cast call` command to invoke the `getChainlinkDataFeedLatestAnswer` method:
   ```bash
   cast call <DEPLOYED_CONTRACT_ADDRESS> "getChainlinkDataFeedLatestAnswer()(int256)" --rpc-url $ETHEREUM_SEPOLIA_RPC_URL
   ```
   Replace `<DEPLOYED_CONTRACT_ADDRESS>` with the actual contract address.

### Option 2: Writing an Interaction Script

1. **Create an Interaction Script**:  
   Create `script/getBTCPrice.s.sol`:
   ```solidity
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
   ```

2. **Run the Interaction Script**:
   Execute the script with:
   ```bash
   forge script script/getBTCPrice.s.sol --rpc-url $ETHEREUM_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
   ```

## Conclusion

You've successfully deployed a smart contract that interacts with the Chainlink BTC/USD price feed on the Sepolia testnet and retrieved the latest price using Foundry's powerful scripting tools.
