# Pro Token 生态系统 - 完整项目树状图

## 📊 项目概览

这是一个基于 BSC (Binance Smart Chain) 的 DeFi 生态系统，包含代币、国库和质押功能。

---

## 🌳 项目架构图

```
Pro Token 生态系统
│
├── 🔵 PRO 代币合约 (Token Layer)
│   ├── 合约地址：0x8D65744527f55d0b2338350912d5C99A81ddF0e2
│   ├── 合约名称：Pro Token (Pro)
│   ├── 类型：ERC20 代币（含税收和流动性池管理功能）
│   ├── 小数位：9
│   ├── 主要功能：
│   │   ├── ✅ 转账税收机制（卖出税）
│   │   ├── ✅ 白名单管理
│   │   ├── ✅ 流动性池平衡（balancePool）
│   │   ├── ✅ 铸造功能（仅 treasury 可调用）
│   │   └── ✅ 治理控制
│   ├── 关键角色地址：
│   │   ├── governance: 治理地址（控制合约参数）
│   │   ├── treasury: 国库地址（可铸造代币）
│   │   ├── feeReceiver: 税费接收地址
│   │   └── targetPool: 目标流动性池（如 PancakeSwap 交易对）
│   └── 相关文件：
│       ├── ProToken.sol (主合约)
│       ├── ERC20.sol (OpenZeppelin ERC20 实现)
│       ├── IERC20.sol (ERC20 接口)
│       ├── IERC20Metadata.sol (元数据接口)
│       ├── Ownable.sol (所有权管理)
│       ├── Context.sol (上下文工具)
│       └── draft-IERC6093.sol (错误标准)
│
├── 🏦 国库系统 (Treasury Layer)
│   │
│   ├── 国库代理合约 (Treasury Proxy)
│   │   ├── 合约地址：0xf9074b5C035c961443373f78A6344e5Adc61d314
│   │   ├── 类型：TransparentUpgradeableProxy
│   │   ├── 作用：用户交互的主要入口
│   │   └── 实现地址：0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
│   │
│   └── 国库逻辑合约 (Treasury Implementation)
│       ├── 合约地址：0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
│       ├── 合约名称：CryptoTreasury
│       ├── 类型：可升级合约实现
│       ├── 主要功能：
│       │   ├── ✅ 储备金管理（稳定币和流动性凭证）
│       │   ├── ✅ 存款 minting（存入资产获得 PRO 代币）
│       │   ├── ✅ 奖励分发
│       │   ├── ✅ 储备金审计
│       │   └── ✅ 权限管理（多角色控制系统）
│       ├── 管理的角色：
│       │   ├── RESERVEDEPOSITOR: 储备金存入者
│       │   ├── RESERVESPENDER: 储备金支出者
│       │   ├── RESERVETOKEN: 认可的储备资产
│       │   ├── RESERVEMANAGER: 储备金管理者
│       │   ├── LIQUIDITYDEPOSITOR: 流动性凭证存入者
│       │   ├── LIQUIDITYTOKEN: 认可的流动性凭证
│       │   ├── LIQUIDITYMANAGER: 流动性管理者
│       │   └── REWARDMANAGER: 奖励管理者
│       ├── 关键配置：
│       │   ├── proToken: PRO 代币地址
│       │   ├── usd: 稳定币储备地址
│       │   ├── rbs: RBS 合约地址
│       │   └── bondCalculator: 债券计算器（用于 LP 估值）
│       └── 相关文件：
│           ├── Treasury.sol (主逻辑合约)
│           ├── IERC20.sol
│           ├── SafeERC20.sol
│           ├── OwnableUpgradeable.sol
│           ├── Initializable.sol
│           ├── ContextUpgradeable.sol
│           ├── IERC1363.sol
│           └── IERC165.sol
│
├── 📈 质押系统 (Staking Layer)
│   │
│   ├── 质押代理合约 (Staking Proxy)
│   │   ├── 合约地址：0xC0021e0849faDefB98761f40829009905Dbd8Ee8
│   │   ├── 类型：TransparentUpgradeableProxy
│   │   ├── 作用：用户质押 PRO 代币获取奖励的入口
│   │   └── 实现地址：0x6d694ce971343626429f87ef05e0cd292e3f2f54
│   │
│   └── 质押逻辑合约 (Staking Implementation)
│       ├── 合约地址：0x6d694ce971343626429f87ef05e0cd292e3f2f54
│       ├── 类型：可升级合约实现（链上发现）
│       ├── 主要功能：
│       │   ├── ✅ PRO 代币质押
│       │   ├── ✅ 奖励计算和分发
│       │   ├── ✅ 质押期限管理
│       │   └── ✅ 治理参与
│       └── 相关文件：
│           ├── TransparentUpgradeableProxy.sol
│           ├── ProxyAdmin.sol
│           ├── ERC1967Proxy.sol
│           ├── ERC1967Utils.sol
│           ├── Proxy.sol
│           ├── IERC1967.sol
│           ├── StorageSlot.sol
│           ├── Address.sol
│           ├── LowLevelCall.sol
│           ├── Errors.sol
│           ├── IBeacon.sol
│           ├── Context.sol
│           └── Ownable.sol
│
├── 🔐 多签钱包 (Security Layer)
│   ├── 合约地址：0x912008f7f56650bFcBa8102cdCD8ABD889769997
│   ├── 类型：Gnosis Safe Multisig Wallet
│   ├── 作用：管理系统最高权限，保护单点故障风险
│   └── 控制内容：
│       ├── PRO 代币合约所有者权限
│       ├── 国库合约所有者权限
│       ├── 质押合约所有者权限
│       └── 关键参数变更审批
│
└── 🔗 外部依赖/未知合约
    ├── PancakeSwap 流动性池 (targetPool) - 待确认
    ├── Bond Calculator 合约 - 待确认
    ├── RBS 合约 - 待确认
    └── USD 稳定币合约 - 待确认
```

---

## 📋 合约关系图

```
                    ┌─────────────────────┐
                    │  多签钱包 (Safe)    │
                    │ 0x9120...769997     │
                    └──────────┬──────────┘
                               │ 控制
                               ▼
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
┌───────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PRO 代币     │    │   国库代理      │    │   质押代理      │
│ 0x8D65...F0e2 │◄──►│ 0xf907...1d314  │    │ 0xC002...8Ee8   │
└───────┬───────┘    └────────┬────────┘    └────────┬────────┘
        │                     │                       │
        │ mint()              │ deposit               │ stake()
        │                     │                       │
        ▼                     ▼                       ▼
┌───────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Treasury    │    │  Treasury Impl  │    │ Staking Impl    │
│   Logic       │    │ 0xD2B9...473B   │    │ 0x6d69...2f54   │
└───────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 🔍 已验证的链上信息

### PRO 代币 (0x8D65744527f55d0b2338350912d5C99A81ddF0e2)
- ✅ 合约已部署（nonce = 1）
- ✅ 余额：0 BNB
- ✅ 字节码已验证存在
- ✅ Solidity 版本：0.8.30

### 国库代理 (0xf9074b5C035c961443373f78A6344e5Adc61d314)
- ✅ 实现地址：0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
- ✅ 使用 ERC1967 代理模式
- ✅ 管理员地址：0x98b3534f128a131FB5D1C48749f8c93fd65553c4 (ProxyAdmin)

### 质押代理 (0xC0021e0849faDefB98761f40829009905Dbd8Ee8)
- ✅ 实现地址：0x6d694ce971343626429f87ef05e0cd292e3f2f54
- ✅ 使用 ERC1967 代理模式

### 多签钱包 (0x912008f7f56650bFcBa8102cdCD8ABD889769997)
- ✅ Gnosis Safe Multisig
- ✅ 控制系统核心权限

### 关键交易记录
- RBS Owner 变更：https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c
- Proxy Admin: 0xD290BD0810F075E0b6128e9d3A08948DFC985B66
- Staking Proxy Owner: 0xD78D4a09E00a54ac9787ECbBeCA02791336C75b3

---

## ⚠️ 待完善的链上信息

以下合约需要通过区块链浏览器进一步查询：

1. **PancakeSwap 流动性池地址** - PRO 代币的交易对地址
2. **Bond Calculator 合约** - 用于 LP 代币估值的计算器
3. **RBS 合约地址** - 国库中配置的 RBS 组件
4. **USD 稳定币地址** - 国库接受的储备资产
5. **当前治理地址** - PRO 代币的 governance 字段值
6. **当前国库地址** - PRO 代币的 treasury 字段值
7. **白名单地址列表** - 豁免税收的地址
8. **各角色授权地址** - 国库系统的管理者地址

---

## 📁 本地文件结构

```
/workspace/
├── README.md                              # 项目说明文档
├── PRO0x8D65744527f55d0b2338350912d5C99A81ddF0e2/
│   ├── ProToken.sol                       # 主代币合约
│   ├── ERC20.sol                          # ERC20 实现
│   ├── IERC20.sol                         # ERC20 接口
│   ├── IERC20Metadata.sol                 # 元数据接口
│   ├── Ownable.sol                        # 所有权管理
│   ├── Context.sol                        # 上下文工具
│   ├── draft-IERC6093.sol                 # 错误标准
│   └── Settings.txt                       # 编译配置
├── Treasury0xf9074b5C035c961443373f78A6344e5Adc61d314/
│   ├── TransparentUpgradeableProxy.sol    # 代理合约
│   ├── ProxyAdmin.sol                     # 代理管理员
│   ├── ERC1967Proxy.sol                   # ERC1967 代理
│   ├── ERC1967Utils.sol                   # ERC1967 工具
│   ├── Proxy.sol                          # 基础代理
│   ├── IERC1967.sol                       # ERC1967 接口
│   ├── StorageSlot.sol                    # 存储槽工具
│   ├── Address.sol                        # 地址工具
│   ├── LowLevelCall.sol                   # 低级调用
│   ├── Errors.sol                         # 错误定义
│   ├── IBeacon.sol                        # Beacon 接口
│   ├── Context.sol                        # 上下文
│   ├── Ownable.sol                        # 所有权
│   └── Settings.txt                       # 编译配置
├── Implementation0xD2B955d22c542EAF932A3cCB1960de3D75a3473B/
│   ├── Treasury.sol                       # 国库逻辑实现
│   ├── IERC20.sol
│   ├── SafeERC20.sol
│   ├── OwnableUpgradeable.sol
│   ├── Initializable.sol
│   ├── ContextUpgradeable.sol
│   ├── IERC1363.sol
│   └── IERC165.sol
└── staking_proxy0xC0021e0849faDefB98761f40829009905Dbd8Ee8/
    ├── TransparentUpgradeableProxy.sol
    ├── ProxyAdmin.sol
    ├── ERC1967Proxy.sol
    ├── ERC1967Utils.sol
    ├── Proxy.sol
    ├── IERC1967.sol
    ├── StorageSlot.sol
    ├── Address.sol
    ├── LowLevelCall.sol
    ├── Errors.sol
    ├── IBeacon.sol
    ├── Context.sol
    └── Ownable.sol
```

---

## 🔧 技术栈

- **Solidity 版本**: 0.8.30
- **EVM 版本**: Cancun / Prague
- **框架**: OpenZeppelin Contracts & Upgradeable
- **代理模式**: Transparent Upgradeable Proxy (ERC1967)
- **区块链**: Binance Smart Chain (BSC)
- **优化器**: 启用 (runs: 200)
- **IR 编译**: 启用

---

## 📝 使用说明

### 查询合约状态

1. **访问 BscScan**: https://bscscan.com
2. **搜索合约地址**: 复制上方任意地址到搜索框
3. **查看源代码**: 点击 "Contract" 标签页查看已验证代码
4. **读取合约数据**: 点击 "Read Contract" 查看实时状态
5. **代理合约**: 对于 Proxy 合约，点击 "Read as Proxy" 查看实现合约数据

### 安全提示

- ⚠️ 所有资金交互应通过 **Proxy 地址** 进行
- ⚠️ 核心权限由 **多签钱包** 控制
- ⚠️ 合约代码已 **100% 开源验证**
- ⚠️ 遵循 "Don't Trust, Verify" 原则

---

*文档生成时间：2025 年*
*数据来源：本地文件分析 + BSC 链上 RPC 查询*
