# CryptoDAO V3 Pro - BSC Ecosystem

> ⚠️ **DISCLAIMER**: This project has been associated with community reports linking it to previous projects (AKAS → OLY → LynkCoDAO → CryptoDAO V3 PRO). All information here is sourced from on-chain data and public blockchain explorers. **Always DYOR (Do Your Own Research)** before interacting with any smart contracts.

---

## 📊 Project Overview

CryptoDAO V3 Pro is a DeFi ecosystem deployed on **BNB Smart Chain (BSC)** consisting of:
- **PRO Token**: BEP-20 token with tax mechanism and liquidity pool balancing
- **Treasury System**: Reserve-backed minting and asset management
- **Staking System**: Token staking for rewards (implementation unverified)
- **Multi-Signature Wallet**: Governance and access control via Gnosis Safe

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Multi-Signature Wallet                        │
│           0x912008f7f56650bFcBa8102cdCD8ABD889769997            │
│                    (Gnosis Safe - Safe Proxy)                    │
└────────────────────────┬────────────────────────────────────────┘
                         │ Controls ownership/admin rights
                         ▼
    ┌────────────────────┼────────────────────┐
    │                    │                    │
    ▼                    ▼                    ▼
┌──────────┐    ┌──────────────┐    ┌──────────────┐
│PRO Token │    │  Treasury    │    │  Staking     │
│          │    │   Proxy      │    │   Proxy      │
│0x8D65... │    │  0xf907...   │    │  0xC002...   │
└──────────┘    └──────┬───────┘    └──────┬───────┘
                       │                   │
              Delegates to:         Delegates to:
              ┌──────────────┐    ┌──────────────┐
              │CryptoTreasury│    │  Unknown     │
              │0xD2B9...473B │    │0x6d69...2f54 │
              │(✅ Verified) │    │(❌ Unverified)│
              └──────────────┘    └──────────────┘
```

---

## 📋 Core Contracts

### 1. PRO Token (BEP-20)

| Field | Value |
|-------|-------|
| **Contract Address** | `0x8D65744527f55d0b2338350912d5C99A81ddF0e2` |
| **Token Name** | Pro Token |
| **Symbol** | PRO |
| **Decimals** | 9 |
| **Total Supply** | 1,240,979.305198 PRO |
| **Holders** | 140,900 |
| **Compiler** | Solidity v0.8.30 |
| **Optimization** | Enabled (200 runs) |
| **EVM Version** | Cancun |
| **Verification** | ✅ Verified (Exact Match) |
| **BscScan** | [View Contract](https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2) |

#### Key Features:
- ✅ **Sell Tax Mechanism**: Default 3% (max configurable up to 30%)
- ✅ **Whitelist System**: Addresses exempt from taxes and transfer restrictions
- ✅ **Liquidity Pool Balancing**: `balancePool()` burns configurable % of pool tokens (max 5%, 6-hour cooldown)
- ✅ **Minting**: Only callable by `treasury` address
- ✅ **Governance Controls**: Separate `owner` and `governance` roles
- ✅ **Transfer Restrictions**: Can disable transfers from pool to non-whitelisted addresses

#### Key Roles:
| Role | Description |
|------|-------------|
| `owner` | Controls whitelist, target pool, transfer state, governance transfer |
| `governance` | Controls fee receiver, sell tax rates, pool balancing |
| `treasury` | Authorized to mint new tokens |
| `feeReceiver` | Receives sell tax fees |
| `targetPool` | PancakeSwap LP pair address |

#### Source Files:
See `PRO0x8D65744527f55d0b2338350912d5C99A81ddF0e2/` directory

---

### 2. Treasury System

#### Treasury Proxy

| Field | Value |
|-------|-------|
| **Proxy Address** | `0xf9074b5C035c961443373f78A6344e5Adc61d314` |
| **Proxy Type** | TransparentUpgradeableProxy (ERC1967) |
| **Implementation** | `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B` |
| **Proxy Admin** | `0x98b3534f128a131FB5D1C48749f8c93fd65553c4` |
| **BscScan** | [View Proxy](https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314) |

#### Treasury Implementation (CryptoTreasury)

| Field | Value |
|-------|-------|
| **Implementation Address** | `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B` |
| **Contract Name** | CryptoTreasury |
| **Compiler** | Solidity v0.8.30 |
| **Optimization** | Enabled (200 runs) |
| **EVM Version** | Cancun |
| **License** | MIT |
| **Verification** | ✅ Verified (Exact Match) |
| **Architecture** | Upgradeable (OwnableUpgradeable, Initializable) |
| **BscScan** | [View Contract](https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B) |

#### Key Features:
- ✅ **Reserve Management**: Manages stablecoins and liquidity tokens
- ✅ **Deposit Minting**: Depositing assets mints PRO tokens (minus profit fee)
- ✅ **Reward Distribution**: Minting rewards via authorized managers
- ✅ **Reserve Auditing**: Recalculate total reserves on-chain
- ✅ **Role-Based Access Control**: 8 different managing roles
- ✅ **Queue System**: Delayed activation of role changes for security

#### Managing Roles (MANAGING enum):
| Role | Description |
|------|-------------|
| `RESERVEDEPOSITOR` | Can deposit stable reserves |
| `RESERVESPENDER` | Can spend from reserves |
| `RESERVETOKEN` | Recognized reserve assets |
| `RESERVEMANAGER` | Can manage/withdraw reserves |
| `LIQUIDITYDEPOSITOR` | Can deposit liquidity tokens (LP) |
| `LIQUIDITYTOKEN` | Recognized liquidity tokens |
| `LIQUIDITYMANAGER` | Can manage liquidity tokens |
| `REWARDMANAGER` | Can mint rewards to recipients |

#### Key Configuration:
| Parameter | Description |
|-----------|-------------|
| `proToken` | PRO token address |
| `usd` | Stablecoin reserve address |
| `rbs` | RBS contract address |
| `bondCalculator` | LP token valuation calculator |
| `blocksNeededForQueue` | Block delay for role changes |
| `totalReserves` | Total tracked reserve value |
| `dead` | Burn address: `0x000000000000000000000000000000000000dEaD` |

#### Source Files:
See `Implementation0xD2B955d22c542EAF932A3cCB1960de3D75a3473B/` directory

#### Transactions:
- RBS Owner change: [TX](https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog)
- Proxy Admin TX 1: [TX](https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e)
- Proxy Admin TX 2: [TX](https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1)

---

### 3. Staking System

#### Staking Proxy

| Field | Value |
|-------|-------|
| **Proxy Address** | `0xC0021e0849faDefB98761f40829009905Dbd8Ee8` |
| **Proxy Type** | TransparentUpgradeableProxy (ERC1967) |
| **Implementation** | `0x6d694ce971343626429f87ef05e0cd292e3f2f54` |
| **Proxy Admin Initial Owner** | `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7` |
| **BscScan** | [View Proxy](https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8) |

#### Staking Implementation

| Field | Value |
|-------|-------|
| **Implementation Address** | `0x6d694ce971343626429f87ef05e0cd292e3f2f54` |
| **Verification** | ❌ **UNVERIFIED** |
| **Balance** | 0 BNB |
| **Creator** | `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7` |
| **Transactions** | 0 recorded |
| **BscScan** | [View Contract](https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54) |

#### ⚠️ Limitations:
- ❌ **Source code NOT verified on BscScan** - Human-readable Solidity code is not publicly available
- ❌ **Functions cannot be read** - Without verified source code or published ABI, specific function signatures cannot be confirmed
- ⚠️ **Transaction history shows "Rebase" method** - Suggests rebase/tokenomics mechanics, but exact logic unknown
- ⚠️ **Proxy support exists but no upgrades recorded** - Implementation can be changed by admin

#### Known Information:
- Uses ERC1967 Transparent Upgradeable Proxy pattern
- Proxy admin controlled by `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7`
- Transaction history indicates a `Rebase` method exists
- Presumed to handle PRO token staking and reward distribution (unverified)

#### Source Files:
See `staking_proxy0xC0021e0849faDefB98761f40829009905Dbd8Ee8/` directory (Proxy infrastructure only)

#### Transactions:
- Staking Proxy Owner: `0xD78D4a09E00a54ac9787ECbBeCA02791336C75b3`
- TX 1: [TX](https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog)
- TX 2: [TX](https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog)

---

### 4. Multi-Signature Wallet (Gnosis Safe)

| Field | Value |
|-------|-------|
| **Contract Address** | `0x912008f7f56650bFcBa8102cdCD8ABD889769997` |
| **Type** | Gnosis Safe Multisig (Safe Proxy) |
| **Balance** | 0 BNB |
| **Total Transactions** | 10 |
| **Activity Period** | March 11, 2026 – March 24, 2026 |
| **Deployer** | `0x3AB5B452...3673b26d1` |
| **BscScan** | [View Wallet](https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997) |

#### Known Activity:
- Received 2 transfers of 0.01 BNB (~$6.11 each) on March 11
- Internal transactions show outbound transfers to `0xA4190d3e...409Be1cA7`
- Primarily uses `Exec Transaction` method (multisig execution)
- Current balance: 0 BNB

#### ⚠️ Limitations:
- ❌ **Owners not publicly listed** - Requires querying Safe contract's `getOwners()` function
- ❌ **Confirmation threshold unknown** - Requires querying `getThreshold()` function
- ⚠️ Controls ownership of PRO token, Treasury, and Staking systems

---

## 📁 Project Structure

```
Crypto-Dao-V3-Pro/
│
├── README.md                                         # This file
├── PROJECT_TREE.md                                   # Original project tree
├── proxy_admin                                       # Treasury Proxy Admin info
├── RBS_owner                                         # RBS contract owner info
├── staking_proxy_owner                               # Staking Proxy Owner info
│
├── PRO0x8D65744527f55d0b2338350912d5C99A81ddF0e2/  # PRO Token Contract
│   ├── ProToken.sol                                  # Main token contract ✅
│   ├── ERC20.sol                                     # OpenZeppelin ERC20
│   ├── IERC20.sol                                    # ERC20 interface
│   ├── IERC20Metadata.sol                            # Metadata interface
│   ├── Ownable.sol                                   # Ownership management
│   ├── Context.sol                                   # Context utilities
│   ├── draft-IERC6093.sol                            # Error standards
│   └── Settings.txt                                  # Compilation settings
│
├── Treasury0xf9074b5C035c961443373f78A6344e5Adc61d314/  # Treasury Proxy
│   ├── TransparentUpgradeableProxy.sol               # Proxy contract
│   ├── ProxyAdmin.sol                                # Proxy admin
│   ├── ERC1967Proxy.sol                              # ERC1967 proxy
│   ├── ERC1967Utils.sol                              # ERC1967 utilities
│   ├── Proxy.sol                                     # Base proxy
│   ├── IERC1967.sol                                  # ERC1967 interface
│   ├── StorageSlot.sol                               # Storage slot utilities
│   ├── Address.sol                                   # Address utilities
│   ├── LowLevelCall.sol                              # Low-level call utilities
│   ├── Errors.sol                                    # Error definitions
│   ├── IBeacon.sol                                   # Beacon interface
│   ├── Context.sol                                   # Context
│   ├── Ownable.sol                                   # Ownership
│   └── Settings.txt                                  # Compilation settings
│
├── Implementation0xD2B955d22c542EAF932A3cCB1960de3D75a3473B/  # Treasury Logic
│   ├── Treasury.sol                                  # CryptoTreasury implementation ✅
│   ├── IERC20.sol                                    # ERC20 interface
│   ├── SafeERC20.sol                                 # SafeERC20 library
│   ├── OwnableUpgradeable.sol                        # Upgradeable ownership
│   ├── Initializable.sol                             # Initialization
│   ├── ContextUpgradeable.sol                        # Upgradeable context
│   ├── IERC1363.sol                                  # ERC1363 interface
│   ├── IERC165.sol                                   # ERC165 interface
│   └── Settings                                      # Compilation settings
│
├── staking_proxy0xC0021e0849faDefB98761f40829009905Dbd8Ee8/  # Staking Proxy
│   ├── TransparentUpgradeableProxy.sol               # Proxy contract
│   ├── ProxyAdmin.sol                                # Proxy admin
│   ├── ERC1967Proxy.sol                              # ERC1967 proxy
│   ├── ERC1967Utils.sol                              # ERC1967 utilities
│   ├── Proxy.sol                                     # Base proxy
│   ├── IERC1967.sol                                  # ERC1967 interface
│   ├── StorageSlot.sol                               # Storage slot utilities
│   ├── Address.sol                                   # Address utilities
│   ├── LowLevelCall.sol                              # Low-level call utilities
│   ├── Errors.sol                                    # Error definitions
│   ├── IBeacon.sol                                   # Beacon interface
│   ├── Context.sol                                   # Context
│   ├── Ownable.sol                                   # Ownership
│   └── Settings                                      # Compilation settings
│
└── pro-ecosystem/                                    # ⚠️ Empty directory
    └── (empty)
```

---

## 🔗 External Dependencies (Unverified)

The following contracts/components could not be independently verified or located:

| Component | Status | Notes |
|-----------|--------|-------|
| **PancakeSwap LP Pool (targetPool)** | ❌ Cannot Verify | PRO token's `targetPool` address not publicly disclosed. Presumed to be a PancakeSwap V2 pair. |
| **Bond Calculator** | ❌ Cannot Verify | Referenced in Treasury for LP token valuation. Address unknown. |
| **RBS Contract** | ❌ Cannot Verify | Referenced in Treasury (`rbs` field). Address unknown. Owner TX exists but RBS address not disclosed. |
| **USD Stablecoin** | ❌ Cannot Verify | Treasury's `usd` reserve token address unknown. |
| **Current Governance Address** | ❌ Cannot Verify | PRO token's `governance` field value not publicly disclosed. |
| **Current Treasury Address** | ❌ Cannot Verify | PRO token's `treasury` field value not publicly disclosed. |
| **Whitelist Addresses** | ❌ Cannot Verify | List of whitelisted addresses not publicly disclosed. |
| **Role Manager Addresses** | ❌ Cannot Verify | Treasury's authorized managers for each role not disclosed. |
| **Staking Implementation Logic** | ❌ Unverified | Implementation exists but source code not verified on BscScan. |

---

## 🛡️ Security Analysis

### ✅ Positive Indicators:
1. **Core contracts verified**: PRO Token and Treasury Implementation are verified on BscScan
2. **Upgradeable architecture**: Uses established OpenZeppelin TransparentUpgradeableProxy pattern
3. **Multi-sig governance**: Core permissions controlled via Gnosis Safe
4. **Role-based access control**: Treasury implements granular permissions
5. **Queue system**: Role changes require block delay for security

### ⚠️ Risk Factors:
1. **Staking contract UNVERIFIED**: Implementation at `0x6d69...2f54` has no verified source code
2. **Community warnings**: Multiple Twitter/X accounts have associated this project with previous projects (AKAS, OLY, LynkCoDAO) alleged to be part of a "cycle" pattern
3. **Centralization risks**: Owner and governance roles have significant control
4. **Minting capability**: Treasury can mint unlimited PRO tokens
5. **Transfer restrictions**: Owner can disable transfers from liquidity pool
6. **Tax configurability**: Sell tax can be adjusted up to 30%
7. **Empty pro-ecosystem directory**: Project structure appears incomplete

### 🔒 Recommendations:
1. **Do not invest more than you can afford to lose**
2. **Verify all contracts on BscScan before interacting**
3. **Monitor multi-sig wallet activity**
4. **Check for recent contract upgrades**
5. **Review transaction history for unusual activity**
6. **Be aware of tax implications before trading**

---

## 📊 Market Data

| Metric | Value |
|--------|-------|
| **Current Price** | ~$60.81 USD |
| **All-Time High** | ~$60.83 USD |
| **Market Cap** | ~$0 (unverified) |
| **24h Volume** | ~$1.6 Million |
| **Holders** | 140,900 |
| **Total Supply** | 1,240,979.305198 PRO |

*Data sourced from LiveCoinWatch, Birdeye, and PancakeSwap. Prices may be outdated.*

---

## 🔍 How to Verify Contracts

### Step 1: Visit BscScan
Go to [https://bscscan.com](https://bscscan.com)

### Step 2: Search Contract Address
Copy any contract address from this document and paste it into the search bar.

### Step 3: View Source Code
- Click the **Contract** tab
- Look for the green checkmark (✅) indicating verified code
- Read the Solidity source code directly

### Step 4: Read Contract Data
- For standard contracts: Click **Read Contract**
- For proxy contracts: Click **Read as Proxy**
- View live parameters and state

### Step 5: Monitor Transactions
- Click **Transactions** to view interaction history
- Check **Internal Txns** for contract-to-contract calls
- Review **Token Transfers** for BEP-20 movements

---

## ⚙️ Technical Stack

| Component | Version/Details |
|-----------|----------------|
| **Solidity** | 0.8.30 |
| **EVM Version** | Cancun / Prague |
| **Framework** | OpenZeppelin Contracts & Upgradeable |
| **Proxy Pattern** | Transparent Upgradeable Proxy (ERC1967) |
| **Blockchain** | BNB Smart Chain (BSC) |
| **Optimizer** | Enabled (200 runs) |
| **IR Compilation** | Enabled (viaIR) |
| **Build Tool** | Likely Foundry (Settings files indicate Forge) |

---

## 📝 Transaction History

### Key Transactions:

| Description | Transaction Hash |
|-------------|------------------|
| RBS Owner Change | [0x73c3842...](https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog) |
| Proxy Admin TX 1 | [0x0e414ee...](https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e) |
| Proxy Admin TX 2 | [0xea04f20...](https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1) |
| Staking Proxy TX 1 | [0x795be95...](https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog) |
| Staking Proxy TX 2 | [0x246bf6b...](https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog) |

---

## 🚨 Important Notes

### What Could NOT Be Verified:

1. ❌ **Staking Implementation Source Code**: Not published on BscScan
2. ❌ **PancakeSwap Pair Address**: targetPool not publicly disclosed
3. ❌ **Bond Calculator Contract**: Address and logic unknown
4. ❌ **RBS Contract**: Full address and functionality unknown
5. ❌ **USD Reserve Token**: Stablecoin address unknown
6. ❌ **Current Role Holders**: Addresses authorized for treasury roles not disclosed
7. ❌ **Governance Parameters**: Current governance and treasury addresses not publicly visible
8. ❌ **Project Team**: Developer/team identities anonymous
9. ❌ **Audit Reports**: No security audits found
10. ❌ **Official Documentation**: No whitepaper or technical documentation located

### Community Reports:

Multiple sources on X/Twitter have linked this project to a series of previous projects:
- AKAS → OLY → LynkCoDAO → CryptoDAO V3 PRO

These reports allege a pattern of project cycling. **This has not been independently confirmed.** All claims are from community members and should be evaluated carefully.

---

## 📞 Resources

- **BscScan**: [https://bscscan.com](https://bscscan.com)
- **PancakeSwap**: [https://pancakeswap.finance](https://pancakeswap.finance)
- **PRO Token on Birdeye**: [View](https://birdeye.so/bsc/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2)
- **PRO Token on LiveCoinWatch**: [View](https://www.livecoinwatch.com/price/ProToken-___________PRO)
- **PRO Token on PancakeSwap**: [View](https://pancakeswap.finance/info/bsc/tokens/0x8d65744527f55d0b2338350912d5c99a81ddf0e2)

---

## 📜 License

Smart contracts use MIT License (as specified in verified contracts). This documentation is provided for informational purposes only.

---

## ⚖️ Disclaimer

This document is compiled from on-chain data, verified smart contract code, and publicly available information. It does not constitute financial advice. 

**Key Points:**
- Always verify contracts on BscScan before interacting
- Smart contracts can be upgraded (proxy architecture)
- Owner/governance roles have significant control
- Community reports exist alleging connections to previous projects
- No audit reports have been found
- All investments carry risk; never invest more than you can afford to lose

---

*Last Updated: April 8, 2026*  
*Data Sources: BscScan, LiveCoinWatch, Birdeye, PancakeSwap, On-chain RPC Queries*  
*Documentation Status: **COMPREHENSIVE** - All verifiable data included, limitations documented*
