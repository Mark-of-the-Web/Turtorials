// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {Bank} from "../src/Bank.sol";
import {console} from "forge-std/console.sol";

contract DeploySimpleBank is Script {
function setUp() public {}

    function run() public {
    // get the private key from the environment variable
      uint privatekey =     vm.envUint("DEV_PRIVATE_KEY"); 
      // convert the private key to an address
      address deployer = vm.addr(privatekey);
      console.log("Deployer", deployer);
        vm.startBroadcast();
        Bank bank = new Bank();
        vm.stopBroadcast();

        
        console.log(
            "Deployed",
            address(bank)
        );
       
    }
}
