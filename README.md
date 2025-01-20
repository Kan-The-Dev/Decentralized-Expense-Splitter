# Decentralized Expense Splitter  

A **smart contract** that allows users to create temporary payment groups, deposit funds equally, and collectively approve or reject payment requests. Members can also **add additional funds** if needed before execution.  

## Features 🚀  

- ✅ **Temporary Payment Groups** – Users can form a group and deposit equal amounts.  
- ✅ **Shared Wallet Ownership** – Each member has an equal share of the group’s balance.  
- ✅ **Approval-Based Payments** – All members must approve a payment request before execution.  
- ✅ **Additional Contributions** – Members can add extra funds when a payment request is made.  
- ✅ **Decentralized & Trustless** – No central authority; funds are only moved when everyone agrees.  

## How It Works 🔥  

1. **Create a Payment Group** – A user creates a temporary payment group and adds members.  
2. **Deposit Funds** – Each member deposits an equal amount into the shared wallet.  
3. **Request a Payment** – Any member can request a payment from the shared wallet.  
4. **Approve or Contribute** – Members must approve the request and can add extra funds if needed.  
5. **Execute Payment** – If all members approve and sufficient funds are available, the payment is processed.  

## Pros 🌟  

- **Full Transparency** – Every transaction is recorded on the blockchain.  
- **No Single Point of Control** – Funds can’t be moved unless all members agree.  
- **Easy Bill Splitting** – Perfect for group expenses like trips, dining, and shared subscriptions.  
- **Flexibility** – Members can contribute additional funds to ensure payments go through.  
- **Secure & Trustless** – No need to rely on a third party to manage shared funds.  

## Smart Contract Overview  

- **Solidity Version:** `^0.8.0`  
- **Functions:**  
  - `createGroup()` – Creates a payment group.  
  - `depositToGroup()` – Deposits funds into the group's shared wallet.  
  - `requestPayment()` – Requests a payment from the group wallet.  
  - `approvePayment()` – Approves a payment request.  
  - `addFundsToPaymentRequest()` – Allows members to add funds to a request.  
  - `executePayment()` – Executes a payment if all approvals are met.  

## Usage  

Deploy the contract on Ethereum or any **EVM-compatible** blockchain (Polygon, BSC, etc.). Use **Remix IDE**, **Hardhat**, or **Truffle** to test and interact with the contract.  

---

Would you like me to add **deployment instructions** or **frontend integration details**? 🚀
