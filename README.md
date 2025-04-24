# 🌳 Merkle Airdrop – Gas-Efficient Airdrop with Merkle Proofs

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-%237212dd)

A smart contract project that implements a **Merkle Tree-based airdrop system** to distribute tokens in a **gas-efficient** and **verifiable** way. This project was completed while following the **Cyfrin Updraft** course, and it helped deepen understanding of key cryptographic and Ethereum transaction concepts.

---

## ✨ Highlights

- ✅ Gas-efficient airdrop using **Merkle Trees**
- 🔐 Merkle Proof verification with OpenZeppelin’s `MerkleProof.sol`
- 🧾 Claim eligibility verification using minimal storage
- ❌ Prevents double-claiming with a bitmap (gas optimized)
- ⚡ Covers signature verification fundamentals using **ECDSA**

---

## 📚 What I Learned

During this build, I explored many advanced Ethereum concepts:

- 🔑 How ECDSA signatures work
- ✍️ V, R, S components of Ethereum signatures
- 📄 EIP-191 & EIP-712 message structures
- ⚙️ Merkle Tree structure & verification
- 🧐 How calldata and transaction types impact cost
- 🟦 Understanding blob transactions & blob gas

---

## 🧠 Tech Stack

- **Solidity** `^0.8.x`
- **Framework**: [Foundry](https://book.getfoundry.sh/)
- **Libraries**: OpenZeppelin `MerkleProof`, `ECDSA`
- **Tools**: `forge coverage`, `forge test`, local scripting

---

## 🧪 Testing

All critical functionality is tested, including:

- ✅ Successful claim with valid Merkle proof
- ❌ Reverts on double claim
- ⚠️ Reverts on invalid proof
- 📡 Proper `Claimed` event emission

Run tests:
```bash
forge test -vv
```

Run coverage:
```bash
forge coverage
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

## 🛠️ Example Usage

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

Built with 🔥 by [@Eunum56](https://github.com/Eunum56)  
> From learning Merkle Trees to mastering cryptographic proofs — this was an essential DeFi building block. Onwards to audits and beyond! 🚀

