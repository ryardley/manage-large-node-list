// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CiphernodeManager.sol";

contract CiphernodeManagerTest is Test {
    CiphernodeManager public manager;
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);

    event CiphernodeAdded(address node, uint256 rank);
    event CiphernodeRemoved(address node, uint256 rank);
    event CiphernodeRankChanged(address node, uint256 oldRank, uint256 newRank);

    function setUp() public {
        manager = new CiphernodeManager();
    }

    function testAddCiphernode() public {
        vm.expectEmit(true, true, false, true);
        emit CiphernodeAdded(alice, 10);
        manager.addCiphernode(alice, 10);

        (address node, uint256 rank) = manager.getCiphernodeAtIndex(0);
        assertEq(node, alice);
        assertEq(rank, 10);
        assertEq(manager.getCiphernodeCount(), 1);
    }

    function testAddDuplicateCiphernode() public {
        manager.addCiphernode(alice, 10);
        vm.expectRevert("Ciphernode already exists");
        manager.addCiphernode(alice, 20);
    }

    function testRemoveCiphernode() public {
        manager.addCiphernode(alice, 10);
        manager.addCiphernode(bob, 20);

        vm.expectEmit(true, true, false, true);
        emit CiphernodeRemoved(alice, 10);
        manager.removeCiphernode(alice);

        assertEq(manager.getCiphernodeCount(), 1);
        (address node, uint256 rank) = manager.getCiphernodeAtIndex(0);
        assertEq(node, bob);
        assertEq(rank, 20);
    }

    function testRemoveNonexistentCiphernode() public {
        vm.expectRevert("Ciphernode does not exist");
        manager.removeCiphernode(alice);
    }

    function testUpdateRank() public {
        manager.addCiphernode(alice, 10);

        vm.expectEmit(true, true, true, true);
        emit CiphernodeRankChanged(alice, 10, 15);
        manager.updateRank(alice, 15);

        (,uint256 rank) = manager.getCiphernodeAtIndex(0);
        assertEq(rank, 15);
    }

    function testUpdateRankNonexistentNode() public {
        vm.expectRevert("Ciphernode does not exist");
        manager.updateRank(alice, 15);
    }

    function testGetCiphernodeCount() public {
        assertEq(manager.getCiphernodeCount(), 0);

        manager.addCiphernode(alice, 10);
        manager.addCiphernode(bob, 20);
        manager.addCiphernode(charlie, 30);

        assertEq(manager.getCiphernodeCount(), 3);

        manager.removeCiphernode(bob);

        assertEq(manager.getCiphernodeCount(), 2);
    }

    function testGetCiphernodeAtIndex() public {
        manager.addCiphernode(alice, 10);
        manager.addCiphernode(bob, 20);

        (address node1, uint256 rank1) = manager.getCiphernodeAtIndex(0);
        assertEq(node1, alice);
        assertEq(rank1, 10);

        (address node2, uint256 rank2) = manager.getCiphernodeAtIndex(1);
        assertEq(node2, bob);
        assertEq(rank2, 20);
    }

    function testGetCiphernodeAtIndexOutOfBounds() public {
        manager.addCiphernode(alice, 10);

        vm.expectRevert("Index out of bounds");
        manager.getCiphernodeAtIndex(1);
    }
}
