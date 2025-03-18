# Crowdfunding System Smart Contract

A robust and gas-efficient **Crowdfunding Smart Contract** system built with Solidity. This project demonstrates a fully functional decentralized crowdfunding platform using the ERC-20 token standard. Designed with security, modularity, and real-world usability in mind, this contract covers the full lifecycle of a crowdfunding campaign.

---

## 🚀 Features

- Launch and cancel campaigns with custom goals and deadlines
- Pledge and unpledge ERC-20 tokens before campaign deadline
- Campaign creators can claim funds if funding goals are met
- Donors are refunded if the campaign fails
- Fully event-driven architecture for easy front-end integration
- Secure and permissioned access control
- Compatible with most ERC-20 tokens

---

## 🔐 Smart Contract Overview

### ✅ Contract Name:
`CrowdfundingSystem`

### 🛠️ Key Concepts Implemented:

- **Struct-based campaign tracking**
- **Nested mappings** for pledge management
- **Access control** with `msg.sender` checks
- **Timestamp validations** for campaign state transitions
- **ERC-20 token interaction** via interface
- **Event emission** for off-chain sync and dApp UI updates

---

## 🧠 Technologies Used

- **Solidity** `^0.8.17`
- **OpenZeppelin standards (optional for integration)**
- **ERC-20 Token Interface**
- **Hardhat / Foundry / Remix** (compatible with most dev tools)

---
## 📌 Functions Overview

| Function         | Description                                               |
|------------------|-----------------------------------------------------------|
| `launchCampaign` | Creates a new campaign with a goal and deadline           |
| `cancelCampaign` | Allows campaign creator to cancel before start            |
| `pledge`         | Users can pledge ERC-20 tokens during campaign            |
| `unpledge`       | Users can retrieve pledged tokens before deadline         |
| `claim`          | Campaign creator claims funds if goal met                 |
| `refund`         | Donors get refund if goal not reached                     |
---
## 📷 Example Use Case

A decentralized donation platform where startups or creators can raise funds in a transparent way.  
Contributors have full control over their funds until the campaign ends, and funds are only released if the funding goal is reached.

---

## ✅ Security Notes

- The contract avoids **reentrancy** by following the [checks-effects-interactions pattern](https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html)
- All sensitive actions are **restricted to campaign creators or donors**
- Funds are handled via a **trusted ERC-20 token interface**


