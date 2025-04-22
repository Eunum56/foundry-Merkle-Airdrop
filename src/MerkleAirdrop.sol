// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// Type declarations
// errors
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;

    // ERRORS
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__InvalidAddress();
    error MerkleAirdrop__AmountBelowZero();
    error MerkleAirdrop__AlreadyClaimed();

    // STATE VARIABLES
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address clamier => bool claimed) private s_hasClaimed;

    // EVENTS
    event Claim(address account, uint256 amount);

    // MODIFIERS

    // FUNCTIONS
    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    // EXTERNAL FUNCTIONS
    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        require(account != address(0), MerkleAirdrop__InvalidAddress());
        require(amount > 0, MerkleAirdrop__AmountBelowZero());
        require(!s_hasClaimed[account], MerkleAirdrop__AlreadyClaimed());
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        require(MerkleProof.verify(merkleProof, i_merkleRoot, leaf), MerkleAirdrop__InvalidProof());
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    // PUBLIC FUNCTIONS

    // INTERNAL FUNCTIONS

    // PRIVATE FUNCTIONS

    // VIEW AND PURE FUNCTION
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
}
