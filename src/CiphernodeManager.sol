// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CiphernodeManager {
    struct Ciphernode {
        uint256 rank;
        uint256 arrayIndex;
        bool exists;
    }

    mapping(address => Ciphernode) public ciphernodes;
    address[] public ciphernodeArray;

    event CiphernodeAdded(address node, uint256 rank);
    event CiphernodeRemoved(address node, uint256 rank);
    event CiphernodeRankChanged(address node, uint256 oldRank, uint256 newRank);

    function addCiphernode(address _node, uint256 _rank) external {
        require(!ciphernodes[_node].exists, "Ciphernode already exists");
        
        ciphernodes[_node] = Ciphernode(_rank, ciphernodeArray.length, true);
        ciphernodeArray.push(_node);

        emit CiphernodeAdded(_node, _rank);
    }

    function removeCiphernode(address _node) external {
        require(ciphernodes[_node].exists, "Ciphernode does not exist");

        uint256 removedRank = ciphernodes[_node].rank;
        uint256 removedIndex = ciphernodes[_node].arrayIndex;
        address lastNode = ciphernodeArray[ciphernodeArray.length - 1];

        // Move the last element to the removed element's position
        ciphernodeArray[removedIndex] = lastNode;
        ciphernodes[lastNode].arrayIndex = removedIndex;

        // Remove the last element
        ciphernodeArray.pop();
        
        // Delete the removed node from the mapping
        delete ciphernodes[_node];

        emit CiphernodeRemoved(_node, removedRank);
    }

    function updateRank(address _node, uint256 _newRank) external {
        require(ciphernodes[_node].exists, "Ciphernode does not exist");
        
        uint256 oldRank = ciphernodes[_node].rank;
        ciphernodes[_node].rank = _newRank;

        emit CiphernodeRankChanged(_node, oldRank, _newRank);
    }

    function getCiphernodeCount() external view returns (uint256) {
        return ciphernodeArray.length;
    }

    function getCiphernodeAtIndex(uint256 _index) external view returns (address, uint256) {
        require(_index < ciphernodeArray.length, "Index out of bounds");
        address node = ciphernodeArray[_index];
        return (node, ciphernodes[node].rank);
    }
}
