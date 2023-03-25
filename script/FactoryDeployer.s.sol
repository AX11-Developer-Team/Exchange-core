// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "forge-std/Script.sol";

import { UniswapV3Factory} from "../src/UniswapV3Factory.sol";

contract FactoryDeploymentScript is Script {
    function setUp() public {}

    function run() public returns (UniswapV3Factory uniswapV3Factory) {
        vm.startBroadcast();
        uniswapV3Factory = new UniswapV3Factory();
        console2.log("Factory address is: ", address(uniswapV3Factory));
        vm.stopBroadcast();
    }
} 

