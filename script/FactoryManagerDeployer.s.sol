// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {FactoryManager} from "../src/FactoryManager.sol";

contract FactoryManagerDeploymentScript is Script {
    function setUp() public {}

    function run() public returns (FactoryManager factorymanager) {
        vm.startBroadcast();
        factorymanager = new FactoryManager();
        console2.log("Factory Manager address is: ", address(factorymanager));
        vm.stopBroadcast();
    }
}