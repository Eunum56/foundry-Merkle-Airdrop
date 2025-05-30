// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";

contract InteractScript is Script {
    address constant CLAMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 constant CLAMING_AMOUNT = 25 * 1e18;

    bytes32 constant PROOF_ONE = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 constant PROOF_TWO = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [PROOF_ONE, PROOF_TWO];

    bytes private SIGNATURE =
        hex"fbd2270e6f23fb5fe9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc511602a2a06c24085d8d7c038bad84edc53664c8ce0346caeaa3570afec0e61144dc11c";

    error __InteractScript__InvalidSignatureLength();

    function claimAirdrop(address airdrop) public {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        vm.startBroadcast();
        MerkleAirdrop(airdrop).claim(CLAMING_ADDRESS, CLAMING_AMOUNT, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65, __InteractScript__InvalidSignatureLength());
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);

        claimAirdrop(mostRecentlyDeployed);
    }
}
