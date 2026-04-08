# Contract Verification Guide

> Step-by-step guide to independently verify all contracts in this project on BscScan.

---

## Quick Start

1. Visit: **https://bscscan.com**
2. Copy any contract address from this project
3. Paste into BscScan search bar
4. Review contract details

---

## Verifying Each Contract

### 1. PRO Token

**Address**: `0x8D65744527f55d0b2338350912d5C99A81ddF0e2`

#### Steps:
1. Go to https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
2. Verify the green checkmark ✅ (Verified Contract)
3. Click **Contract** tab
4. Click **Code** to read Solidity source code
5. Click **Read Contract** to view live parameters
6. Check these key values:
   - `sellRatio()` - Current sell tax (basis points)
   - `governance()` - Governance address
   - `treasury()` - Treasury address
   - `targetPool()` - Liquidity pool address
   - `transferStatus()` - Transfer enabled flag
   - `feeReceiver()` - Fee collection address

#### What to Look For:
- ✅ Compiler version matches (v0.8.30)
- ✅ Optimization enabled (200 runs)
- ✅ Exact Match status
- ⚠️ Any recent code changes
- ⚠️ Unusual parameter values

---

### 2. Treasury Proxy

**Address**: `0xf9074b5C035c961443373f78A6344e5Adc61d314`

#### Steps:
1. Go to https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314
2. Click **Contract** tab
3. Note this is a **Proxy** contract
4. Click **Read as Proxy**
5. Check:
   - Implementation address
   - Admin address
   - Recent upgrade transactions

#### What to Look For:
- ✅ Proxy pattern implementation
- ✅ Known implementation address
- ⚠️ Recent proxy upgrades
- ⚠️ Changes to admin

---

### 3. Treasury Implementation (CryptoTreasury)

**Address**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`

#### Steps:
1. Go to https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
2. Verify green checkmark ✅ (Verified Contract)
3. Click **Contract** tab
4. Click **Code** to read source code
5. Click **Read Contract** to view parameters
6. Check these key values:
   - `proToken()` - Should be PRO token address
   - `totalReserves()` - Total reserve value
   - `usd()` - Stablecoin reserve address
   - `rbs()` - RBS contract address
   - `blocksNeededForQueue()` - Queue delay
   - `owner()` - Contract owner

#### What to Look For:
- ✅ Verified source code
- ✅ MIT License
- ✅ Expected parameter values
- ⚠`reserveTokens[]` - Approved reserve assets
- ⚠ `liquidityTokens[]` - Approved LP tokens
- ⚠ Role manager addresses

---

### 4. Staking Proxy

**Address**: `0xC0021e0849faDefB98761f40829009905Dbd8Ee8`

#### Steps:
1. Go to https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8
2. Click **Contract** tab
3. Note this is a **Proxy** contract
4. Click **Read as Proxy**
5. Check implementation address
6. Monitor for upgrades

#### What to Look For:
- ✅ Proxy pattern
- ⚠️ Implementation is UNVERIFIED
- ⚠️ No recorded upgrades
- ⚠️ Unknown functionality

---

### 5. Staking Implementation ⚠️

**Address**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`

#### Steps:
1. Go to https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54
2. Note: **NO GREEN CHECKMARK** ❌
3. Source code is **NOT VERIFIED**
4. Only bytecode is available
5. Cannot read functions or logic

#### ⚠️ WARNING:
- **DO NOT INTERACT** until code is verified
- Cannot audit functionality
- Unknown reward mechanism
- Potential hidden risks

#### What You Can Check:
- Balance (currently 0 BNB)
- Transaction count (currently 0)
- Creator address
- Bytecode (not human-readable)

---

### 6. Multi-Signature Wallet (Gnosis Safe)

**Address**: `0x912008f7f56650bFcBa8102cdCD8ABD889769997`

#### Steps:
1. Go to https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD889769997
2. Click **Contract** tab
3. Click **Read Contract**
4. Query these functions (if available):
   - `getOwners()` - List of owner addresses
   - `getThreshold()` - Required confirmations
   - `nonce()` - Transaction count

#### What to Look For:
- ✅ Safe contract pattern
- ⚠️ Owners not publicly listed by default
- ⚠️ Threshold unknown
- Transaction history
- Internal transactions

---

## Understanding Proxy Architecture

### What is a Proxy?

A proxy contract separates the **storage** from the **logic**:
- **Proxy**: Holds state and delegates calls
- **Implementation**: Contains actual business logic
- **Admin**: Can upgrade implementation

### Why Use Proxies?

1. **Upgradeability**: Logic can be changed without losing state
2. **Gas Efficiency**: Users interact with same address
3. **Bug Fixes**: Vulnerabilities can be patched

### Risks of Proxies

1. **Admin Control**: Admin can change implementation
2. **Hidden Logic**: New implementation could be malicious
3. **Trust Required**: Must trust current and future implementations

### How to Monitor

1. Watch for `upgradeToAndCall` transactions
2. Check implementation address changes
3. Review new implementation code after upgrades
4. Monitor admin address activity

---

## Reading Contract Data

### Key Metrics to Monitor

#### PRO Token
```
sellRatio()        → Current sell tax (basis points)
transferStatus()   → Transfers enabled?
targetPool()       → Liquidity pool address
governance()       → Governance address
treasury()         → Treasury address
```

#### Treasury
```
totalReserves()    → Total reserve value
proToken()         → PRO token address
supplied()         → Total PRO supply
excessReserves()   → Available for rewards
owner()            → Contract owner
```

### Understanding Basis Points

- 1 basis point = 0.01%
- 100 = 1%
- 300 = 3% (default sell tax)
- 3000 = 30% (max sell tax)
- 500 = 5% (max pool burn)

---

## Common Verification Checks

### ✅ Good Signs
- [x] Green checkmark on BscScan
- [x] "Exact Match" status
- [x] Solidity source code readable
- [x] Uses OpenZeppelin libraries
- [x] Reasonable compiler version
- [x] Optimization enabled
- [x] Active transaction history

### ❌ Red Flags
- [ ] No verification (no green checkmark)
- [ ] Only bytecode available
- [ ] Cannot read functions
- [ ] Very new contract
- [ ] No transactions
- [ ] Suspicious creator
- [ ] Unusual compiler settings

---

## Monitoring Tools

### BscScan Features
1. **Watchlist**: Add contracts to monitor
2. **Alerts**: Email notifications for transactions
3. **API**: Programmatic access to data
4. **Token Tracker**: Monitor token holdings

### External Tools
- **Birdeye**: https://birdeye.so (price, volume, holders)
- **PancakeSwap**: https://pancakeswap.finance (trading, liquidity)
- **DeFiLlama**: https://defillama.com (TVL tracking)

---

## What to Do If You Find Issues

### If Contract is Not Verified
1. Do NOT interact with the contract
2. Request verification from team
3. Warn others in community
4. Report to BscScan if suspicious

### If You Spot Suspicious Activity
1. Document transaction hashes
2. Take screenshots
3. Report to community
4. Contact BscScan support

### If Parameters Change
1. Note what changed
2. Check who initiated
3. Assess impact
4. Decide whether to continue using

---

## Quick Reference

| Contract | Status | BscScan Link |
|----------|--------|--------------|
| PRO Token | ✅ Verified | [Link](https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2) |
| Treasury Proxy | ✅ Deployed | [Link](https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314) |
| Treasury Impl | ✅ Verified | [Link](https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B) |
| Staking Proxy | ✅ Deployed | [Link](https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8) |
| Staking Impl | ❌ Unverified | [Link](https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54) |
| Multisig | ✅ Deployed | [Link](https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997) |

---

## Additional Resources

- **BscScan Guide**: https://bscscan.com/label/cloud
- **OpenZeppelin Docs**: https://docs.openzeppelin.com/contracts/
- **Proxy Patterns**: https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
- **Smart Contract Verification**: https://ethereum.org/en/developers/docs/smart-contracts/verifying/

---

*Last Updated: April 8, 2026*  
*Status: COMPLETE GUIDE*
