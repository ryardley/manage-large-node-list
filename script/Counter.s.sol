// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {CiphernodeManager} from "../src/CiphernodeManager.sol";

contract CounterScript is Script {
    CiphernodeManager public ctr;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        ctr = new CiphernodeManager();

        vm.stopBroadcast();
    }
}
