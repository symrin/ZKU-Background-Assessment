// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract MerkleTree {
    bytes32[] public hashes;
    bytes32[] public transactions;

    //create a Merkle Tree
    function addLeaf(
        address receiver,
        uint256 tokenId,
        string memory tokenURI
    ) public {
        delete hashes;

    //add hashed transactions/leaves into the transactions array
        transactions.push(
            keccak256(abi.encodePacked(msg.sender, receiver, tokenId, tokenURI))
        );

    //add transactions to the hashes array 
        for (uint256 i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }
        uint256 n = transactions.length;
        uint256 offset = 0;

        while (n > 0) {
            for (uint256 i = 0; i < n-1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
                    )
                );
            }
            offset += n;
            n = n / 2;
        }
    }

    function getMerkleRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    function getTransactionsLength() public view returns (uint256) {
        return transactions.length;
    }
}
