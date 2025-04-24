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
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712 {
    using SafeERC20 for IERC20;

    // TYPE DECLARATIONS
    struct AirdropClaim {
        address account;
        uint256 amount;
    }

    // ERRORS
    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__InvalidAddress();
    error MerkleAirdrop__AmountBelowZero();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    // STATE VARIABLES
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address clamier => bool claimed) private s_hasClaimed;
    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account, uint256 amount)");

    // EVENTS
    event Claim(address account, uint256 amount);

    // MODIFIERS

    // FUNCTIONS
    constructor(bytes32 merkleRoot, IERC20 airdropToken) EIP712("MerkleAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    // EXTERNAL FUNCTIONS
    function claim(address account, uint256 amount, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s)
        external
    {
        require(account != address(0), MerkleAirdrop__InvalidAddress());
        require(amount > 0, MerkleAirdrop__AmountBelowZero());
        require(!s_hasClaimed[account], MerkleAirdrop__AlreadyClaimed());

        // check the signature
        require(_isValidSignature(account, getMessage(account, amount), v, r, s), MerkleAirdrop__InvalidSignature());
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        require(MerkleProof.verify(merkleProof, i_merkleRoot, leaf), MerkleAirdrop__InvalidProof());
        s_hasClaimed[account] = true;
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }

    // PUBLIC FUNCTIONS
    function getMessage(address account, uint256 amount) public view returns (bytes32) {
        return
            _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({account: account, amount: amount}))));
    }

    // INTERNAL FUNCTIONS
    function _isValidSignature(address account, bytes32 digest, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
    }

    // PRIVATE FUNCTIONS

    // VIEW AND PURE FUNCTION
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
}
