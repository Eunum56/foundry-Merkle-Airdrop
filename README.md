# 🌳 Merkle Airdrop – Gas-Efficient Airdrop with Merkle Proofs

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-%237212dd)

This project implements a **gas-efficient Merkle Airdrop system**, allowing eligible users to claim tokens by submitting a Merkle proof that validates their address and allocation.

Built while following the **Cyfrin Updraft** course, this project demonstrates how to securely handle large-scale airdrops **without storing all user data on-chain**.

---

## ✨ Features

- ✅ Efficient token distribution without storing every recipient on-chain
- 🌳 Uses **Merkle Trees** to validate claims
- 🛡️ Prevents double-claiming with a bitmap (gas optimized)
- 🔐 Verifies proofs with `MerkleProof.verify()` from OpenZeppelin
- 📦 Compatible with Foundry and Forge testing

---

## 📚 How It Works

1. Off-chain, you build a **Merkle Tree** from a list of eligible addresses and allocations.
2. The contract stores only the **Merkle Root** on-chain.
3. Each user can claim tokens by submitting:
   - Their index
   - Address
   - Allocated amount
   - Merkle proof
4. The contract checks:
   - If they’ve already claimed
   - If their Merkle proof is valid
5. If valid, it sends them the airdropped tokens and marks them as claimed.

---

## 🔧 Tech Stack

- **Solidity** `^0.8.24`
- **Framework**: [Foundry](https://book.getfoundry.sh/)
- **Libraries**: OpenZeppelin's `MerkleProof.sol`
- **Tools**: Forge tests, hardcoded Merkle root for simplicity

---

## 🧪 Testing

Tests cover:

- ✅ Successful claim with valid proof
- ⚠️ Reverts on invalid proof
- ❌ Reverts on double claim
- 🩵 Emits `Claim` event

To run tests:

```bash
forge test -vv
```

---

## 📂 File Structure

```
.
├── src/
│   └── MerkleAirdrop.sol
│
├── test/
│   └── MerkleAirdrop.t.sol
│
├── script/
│   └── DeployMerkleAirdrop.s.sol
└── foundry.toml
```

---

## 🧪 Example Claim Call

```solidity
airdrop.claim(
    0,                      // index
    0xYourAddress,          // claimer
    1000 * 1e18,            // amount
    proof                   // bytes32[] calldata
);
```

---

## 📜 License

MIT © 2024

---

## 👨‍💻 Author

Made with 💡 and `forge coverage` by [Muzammil](https://github.com/Eunum56)  
> Another step closer to smart contract mastery. On-chain, on-point. 🔗🚀

