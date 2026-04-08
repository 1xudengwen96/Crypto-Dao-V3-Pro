# Complete Contract Addresses Registry

> All addresses verified through on-chain data and BscScan queries.
> Last updated: April 8, 2026

---

## Core Contracts

### PRO Token (BEP-20)
- **Address**: `0x8D65744527f55d0b2338350912d5C99A81ddF0e2`
- **Status**: ✅ Verified (Exact Match)
- **BscScan**: https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
- **Compiler**: Solidity v0.8.30
- **Optimization**: Enabled (200 runs)
- **EVM Version**: Cancun

### Treasury Proxy
- **Proxy Address**: `0xf9074b5C035c961443373f78A6344e5Adc61d314`
- **Status**: ✅ Deployed (TransparentUpgradeableProxy)
- **BscScan**: https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314
- **Implementation**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`
- **Proxy Admin**: `0x98b3534f128a131FB5D1C48749f8c93fd65553c4`

### Treasury Implementation (CryptoTreasury)
- **Address**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`
- **Status**: ✅ Verified (Exact Match)
- **BscScan**: https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
- **Contract Name**: CryptoTreasury
- **Compiler**: Solidity v0.8.30
- **License**: MIT

### Staking Proxy
- **Proxy Address**: `0xC0021e0849faDefB98761f40829009905Dbd8Ee8`
- **Status**: ✅ Deployed (TransparentUpgradeableProxy)
- **BscScan**: https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8
- **Implementation**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`
- **Proxy Admin Initial Owner**: `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7`

### Staking Implementation
- **Address**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`
- **Status**: ❌ UNVERIFIED
- **BscScan**: https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54
- **Creator**: `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7`
- **Balance**: 0 BNB
- **Transactions**: 0 recorded

### Multi-Signature Wallet (Gnosis Safe)
- **Address**: `0x912008f7f56650bFcBa8102cdCD8ABD889769997`
- **Status**: ✅ Deployed (Safe Proxy)
- **BscScan**: https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997
- **Deployer**: `0x3AB5B452...3673b26d1`
- **Total Transactions**: 10
- **Activity Period**: March 11-24, 2026

---

## Known Role Holders

### Treasury System
- **RBS Contract Owner**: `0xD290BD0810F075E0b6128e9d3A08948DFC985B66`
  - TX: https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog
- **Staking Proxy Owner**: `0xD78D4a09E00a54ac9787ECbBeCA02791336C75b3`
  - TX 1: https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog
  - TX 2: https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog

### Proxy Admin Transactions
- **Treasury Proxy Admin TX 1**: https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e
- **Treasury Proxy Admin TX 2**: https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1

---

## Unknown/Undisclosed Addresses

The following addresses could NOT be determined from on-chain data or public sources:

| Component | Status | Notes |
|-----------|--------|-------|
| PancakeSwap LP Pool (targetPool) | ❌ Unknown | PRO token's target liquidity pool |
| Bond Calculator | ❌ Unknown | LP token valuation contract |
| RBS Contract (full address) | ❌ Unknown | Only owner address known |
| USD Stablecoin Reserve | ❌ Unknown | Treasury's accepted stablecoin |
| Current Governance Address | ❌ Unknown | PRO token's governance field |
| Current Treasury Address | ❌ Unknown | PRO token's treasury field |
| Whitelist Addresses | ❌ Unknown | Exempt addresses |
| Role Manager Addresses | ❌ Unknown | All 8 role types |
| Multisig Owners | ❌ Unknown | Safe wallet owners |
| Multisig Threshold | ❌ Unknown | Required confirmations |

---

## External Links

- **BscScan**: https://bscscan.com
- **PancakeSwap Info**: https://pancakeswap.finance/info/bsc/tokens/0x8d65744527f55d0b2338350912d5c99a81ddf0e2
- **Birdeye**: https://birdeye.so/bsc/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
- **LiveCoinWatch**: https://www.livecoinwatch.com/price/ProToken-___________PRO
