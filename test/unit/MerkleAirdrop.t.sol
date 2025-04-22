// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";

import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {MernToken} from "../../src/MernToken.sol";
import {DeployMerkleAirdrop} from "../../script/DeployMerkleAirdrop.s.sol";

import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract MerkleAirdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop public airdrop;
    MernToken public token;
    uint256 constant AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 constant AMOUNT_TO_MINT = AMOUNT_TO_CLAIM * 4;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;

    bytes32 public proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 public proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];

    address public user;
    uint256 userPriKey;

    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (airdrop, token) = deployer.run();
        } else {
            token = new MernToken();
            airdrop = new MerkleAirdrop(ROOT, token);
            token.mint(token.owner(), AMOUNT_TO_MINT);
            token.transfer(address(airdrop), AMOUNT_TO_MINT);
        }
        (user, userPriKey) = makeAddrAndKey("user");
    }

    function testUserCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);

        vm.prank(user);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);

        uint256 endingBalance = token.balanceOf(user);
        console.log("Ending Balance", endingBalance);
        assertEq(endingBalance - startingBalance, AMOUNT_TO_CLAIM);
    }
}
