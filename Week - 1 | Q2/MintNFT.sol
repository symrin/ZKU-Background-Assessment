// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";
import "MerkleTree.sol";

contract MintNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    MerkleTree private merkleTree;

    bytes32[] hashes;

    event NewMintedNFT(address sender, uint256 tokenId);

    constructor() ERC721 ("NFT", "Contract") {
        merkleTree = new MerkleTree();
    }

    function getNFTsMintedSoFar() public  {
    console.log("so far we've printed ");
    console.log(" NFTs");
    makeAnNFT(msg.sender);
  }

    function makeAnNFT(address receiver) public {
        uint256 newItemId = _tokenIds.current();

        string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    Strings.toString(newItemId),
                    '", "description": "NFT id = ',
                    Strings.toString(newItemId),'"}'
                )
            )
        )
    );
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    merkleTree.addLeaf(
            receiver,
            newItemId,
            finalTokenUri
        );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(receiver, newItemId);
    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();
    emit NewMintedNFT(msg.sender, newItemId);
    }
}