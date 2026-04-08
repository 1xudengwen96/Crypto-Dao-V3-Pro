# 完整合约地址注册表

> 所有地址均通过链上数据和 BscScan 查询验证。
> 最后更新：2026 年 4 月 8 日

---

## 核心合约

### PRO 代币 (BEP-20)
- **地址**: `0x8D65744527f55d0b2338350912d5C99A81ddF0e2`
- **状态**: ✅ 已验证（精确匹配）
- **BscScan**: https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
- **编译器**: Solidity v0.8.30
- **优化**: 已启用（200 次运行）
- **EVM 版本**: Cancun

### 国库代理
- **代理地址**: `0xf9074b5C035c961443373f78A6344e5Adc61d314`
- **状态**: ✅ 已部署（TransparentUpgradeableProxy）
- **BscScan**: https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314
- **实现地址**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`
- **代理管理员**: `0x98b3534f128a131FB5D1C48749f8c93fd65553c4`

### 国库实现（CryptoTreasury）
- **地址**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`
- **状态**: ✅ 已验证（精确匹配）
- **BscScan**: https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
- **合约名称**: CryptoTreasury
- **编译器**: Solidity v0.8.30
- **许可证**: MIT

### 质押代理
- **代理地址**: `0xC0021e0849faDefB98761f40829009905Dbd8Ee8`
- **状态**: ✅ 已部署（TransparentUpgradeableProxy）
- **BscScan**: https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8
- **实现地址**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`
- **代理管理员初始所有者**: `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7`

### 质押实现
- **地址**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`
- **状态**: ❌ 未验证
- **BscScan**: https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54
- **创建者**: `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7`
- **余额**: 0 BNB
- **交易数**: 0 笔记录

### 多签钱包（Gnosis Safe）
- **地址**: `0x912008f7f56650bFcBa8102cdCD8ABD889769997`
- **状态**: ✅ 已部署（Safe 代理）
- **BscScan**: https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997
- **部署者**: `0x3AB5B452...3673b26d1`
- **总交易数**: 10 笔
- **活跃期**: 2026 年 3 月 11 日 - 24 日

---

## 已知角色持有者

### 国库系统
- **RBS 合约所有者**: `0xD290BD0810F075E0b6128e9d3A08948DFC985B66`
  - 交易: https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog
- **质押代理所有者**: `0xD78D4a09E00a54ac9787ECbBeCA02791336C75b3`
  - 交易 1: https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog
  - 交易 2: https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog

### 代理管理员交易
- **国库代理管理员交易 1**: https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e
- **国库代理管理员交易 2**: https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1

---

## 未知/未披露地址

以下地址无法从链上数据或公开来源确定：

| 组件 | 状态 | 说明 |
|-----------|--------|-------|
| PancakeSwap 流动性池（targetPool） | ❌ 未知 | PRO 代币的目标流动性池 |
| 债券计算器（Bond Calculator） | ❌ 未知 | LP 代币估值合约 |
| RBS 合约（完整地址） | ❌ 未知 | 仅知道所有者地址 |
| USD 稳定币储备 | ❌ 未知 | 国库接受的稳定币 |
| 当前治理地址 | ❌ 未知 | PRO 代币的 governance 字段 |
| 当前国库地址 | ❌ 未知 | PRO 代币的 treasury 字段 |
| 白名单地址列表 | ❌ 未知 | 免税/免除限制的地址 |
| 角色管理者地址 | ❌ 未知 | 所有 8 种角色类型 |
| 多签所有者 | ❌ 未知 | Safe 钱包所有者 |
| 多签阈值 | ❌ 未知 | 所需的确认数 |

---

## 外部链接

- **BscScan**: https://bscscan.com
- **PancakeSwap 信息**: https://pancakeswap.finance/info/bsc/tokens/0x8d65744527f55d0b2338350912d5c99a81ddf0e2
- **Birdeye**: https://birdeye.so/bsc/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
- **LiveCoinWatch**: https://www.livecoinwatch.com/price/ProToken-___________PRO
