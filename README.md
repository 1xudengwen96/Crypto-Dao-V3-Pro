# CryptoDAO V3 Pro - BSC 生态生态系统

> ⚠️ **免责声明**：本项目被社区报告与之前的项目（AKAS → OLY → LynkCoDAO → CryptoDAO V3 PRO）有关联。此处所有信息均来自链上数据和公开区块链浏览器。**请务必自行研究（DYOR）**，在与任何智能合约交互之前谨慎评估风险。

---

## 📊 项目概述

CryptoDAO V3 Pro 是部署在 **币安智能链（BSC）** 上的 DeFi 生态系统，包含：
- **PRO 代币**：BEP-20 代币，具有税收机制和流动性池平衡功能
- **国库系统**：基于储备金的铸造和资产管理
- **质押系统**：代币质押获取奖励（实现合约未验证）
- **多签钱包**：通过 Gnosis Safe 进行治理和访问控制

---

## 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────────────┐
│                        多签钱包                                   │
│           0x912008f7f56650bFcBa8102cdCD8ABD889769997            │
│                    (Gnosis Safe - Safe 代理)                     │
└────────────────────────┬────────────────────────────────────────┘
                         │ 控制所有权/管理权限
                         ▼
    ┌────────────────────┼────────────────────┬────────────────┐
    │                    │                    │                │
    ▼                    ▼                    ▼                ▼
┌──────────┐    ┌──────────────┐    ┌──────────────┐   ┌──────────┐
│PRO 代币   │    │   国库代理    │    │   质押代理    │   │ RBS 代理 │
│0x8D65... │    │  0xf907...   │    │  0xC002...   │   │0xc2d8... │
└──────────┘    └──────┬───────┘    └──────┬───────┘   └────┬─────┘
                       │                   │                │
              委托调用:             委托调用:          委托调用:
              ┌──────────────┐    ┌──────────────┐   ┌──────────┐
              │CryptoTreasury│    │  未知实现       │   │RBSControl│
              │0xD2B9...473B │    │0x6d69...2f54 │   │0x309c... │
              │(✅ 已验证)    │    │(❌ 未验证)    │   │(✅ 已验证)│
              └──────────────┘    └──────────────┘   └──────────┘
                       ▲                                │
                       │ 调用 depositStableReserve()   │ 铸造 PRO
                       └────────────────────────────────┘
```

---

## 📋 核心合约

### 1. PRO 代币 (BEP-20)

| 字段 | 值 |
|-------|-------|
| **合约地址** | `0x8D65744527f55d0b2338350912d5C99A81ddF0e2` |
| **代币名称** | Pro Token |
| **符号** | PRO |
| **小数位** | 9 |
| **总供应量** | 1,240,979.305198 PRO |
| **持有者数量** | 140,900 |
| **编译器** | Solidity v0.8.30 |
| **优化** | 已启用（200 次运行） |
| **EVM 版本** | Cancun |
| **验证状态** | ✅ 已验证（精确匹配） |
| **BscScan** | [查看合约](https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2) |

#### 核心功能：
- ✅ **卖出税收机制**：默认 3%（最高可配置至 30%）
- ✅ **白名单系统**：免除税收和转账限制的地址
- ✅ **流动性池平衡**：`balancePool()` 燃烧可配置比例的池代币（最高 5%，6 小时冷却）
- ✅ **铸造功能**：仅 `treasury` 地址可调用
- ✅ **治理控制**：分离的 `owner` 和 `governance` 角色
- ✅ **转账限制**：可禁用从池到非白名单地址的转账

#### 关键角色：
| 角色 | 描述 |
|------|-------------|
| `owner` | 控制白名单、目标池、转账状态、治理权转移 |
| `governance` | 控制费接收者、卖出税率、池平衡 |
| `treasury` | 授权铸造新代币 |
| `feeReceiver` | 接收卖出税收费用 |
| `targetPool` | PancakeSwap LP 交易对地址 |

#### 源文件：
见 `contracts/PRO_Token/` 目录

---

### 2. 国库系统

#### 国库代理

| 字段 | 值 |
|-------|-------|
| **代理地址** | `0xf9074b5C035c961443373f78A6344e5Adc61d314` |
| **代理类型** | TransparentUpgradeableProxy (ERC1967) |
| **实现地址** | `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B` |
| **代理管理员** | `0x98b3534f128a131FB5D1C48749f8c93fd65553c4` |
| **BscScan** | [查看代理](https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314) |

#### 国库实现（CryptoTreasury）

| 字段 | 值 |
|-------|-------|
| **实现地址** | `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B` |
| **合约名称** | CryptoTreasury |
| **编译器** | Solidity v0.8.30 |
| **优化** | 已启用（200 次运行） |
| **EVM 版本** | Cancun |
| **许可证** | MIT |
| **验证状态** | ✅ 已验证（精确匹配） |
| **架构** | 可升级（OwnableUpgradeable, Initializable） |
| **BscScan** | [查看合约](https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B) |

#### 核心功能：
- ✅ **储备金管理**：管理稳定币和流动性代币
- ✅ **存款铸造**：存入资产铸造 PRO 代币（减去利润费）
- ✅ **奖励分发**：通过授权管理者铸造奖励
- ✅ **储备金审计**：链上重新计算总储备金
- ✅ **基于角色的访问控制**：8 种不同的管理角色
- ✅ **队列系统**：角色变更延迟激活以提高安全性

#### 管理角色（MANAGING 枚举）：
| 角色 | 描述 |
|------|-------------|
| `RESERVEDEPOSITOR` | 可存入稳定储备金 |
| `RESERVESPENDER` | 可支出储备金 |
| `RESERVETOKEN` | 已认可的储备资产 |
| `RESERVEMANAGER` | 可管理/提取储备金 |
| `LIQUIDITYDEPOSITOR` | 可存入流动性代币（LP） |
| `LIQUIDITYTOKEN` | 已认可的流动性代币 |
| `LIQUIDITYMANAGER` | 可管理流动性代币 |
| `REWARDMANAGER` | 可向接收者铸造奖励 |

#### 关键配置：
| 参数 | 描述 |
|-----------|-------------|
| `proToken` | PRO 代币地址 |
| `usd` | 稳定币储备地址 |
| `rbs` | RBS 合约地址：`0xc2d8595fe8d904a8665059d68a6fa2467df09a13` |
| `bondCalculator` | LP 代币估值计算器 |
| `blocksNeededForQueue` | 角色变更的区块延迟 |
| `totalReserves` | 总追踪储备价值 |
| `dead` | 燃烧地址：`0x000000000000000000000000000000000000dEaD` |

#### 源文件：
见 `contracts/Treasury_Implementation/` 目录

#### 关键交易：
- RBS 所有者变更：[交易](https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog)
- 代理管理员交易 1：[交易](https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e)
- 代理管理员交易 2：[交易](https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1)

---

### 2.1 RBS 合约（Reserve Backing System）

#### RBS 代理

| 字段 | 值 |
|-------|-------|
| **代理地址** | `0xc2d8595fe8d904a8665059d68a6fa2467df09a13` |
| **代理类型** | TransparentUpgradeableProxy (EIP-1967) |
| **实现地址** | `0x309c177f3ae5a4132427895ab5cd005f181adefa` |
| **验证状态** | ✅ 已验证 |
| **BscScan** | [查看合约](https://bscscan.com/address/0xc2d8595fe8d904a8665059d68a6fa2467df09a13) |

#### RBS 实现（RBSControl）

| 字段 | 值 |
|-------|-------|
| **合约名称** | RBSControl |
| **编译器** | Solidity v0.8.30 |
| **优化** | 已启用（200 次运行） |
| **EVM 版本** | Prague |
| **验证状态** | ✅ 已验证（精确匹配） |
| **持有资产** | ~5,208,232 BSC-USD（约 $520 万） |
| **总交易数** | 655+ 笔 |
| **BscScan** | [查看源代码](https://bscscan.com/address/0x309c177f3ae5a4132427895ab5cd005f181adefa#code) |

#### 核心功能：
- ✅ **代币兑换**：通过 PancakeSwap 进行代币交换
- ✅ **流动性管理**：添加流动性并获取 LP 代币
- ✅ **铸造 PRO 代币**：通过国库系统铸造新的 PRO 代币（每 30 分钟最多 200,000 USD）
- ✅ **LP 代币燃烧**：燃烧 LP 代币以减少流动性
- ✅ **价格查询**：查询代币价格和流动性信息

#### 关键函数：
| 函数 | 说明 | 访问控制 |
|------|------|----------|
| `mint()` | 存入 USD 铸造 PRO 代币 | onlyOwner |
| `swap()` | 执行代币交换 | onlyOwner |
| `addLiquidity()` | 添加流动性 | onlyOwner |
| `burnLP()` | 燃烧 LP 代币 | onlyOwner |
| `getTokenPrice()` | 查询代币价格 | 公开查看 |

#### 铸造限制：
| 限制 | 值 |
|------|-----|
| 铸造冷却时间 | 30 分钟 |
| 单次最大铸造 | 200,000 USD |
| PRO 余额限制 | < 20,000 PRO |

#### 源文件：
见 `contracts/RBS_Implementation/` 目录

#### 设置交易：
- RBS 合约设置：[交易](https://bscscan.com/tx/0x70e1ec94353845057b482800a310a746e65b3b692ad53918258a3ebbc50d2775)

---

### 3. 质押系统

#### 质押代理

| 字段 | 值 |
|-------|-------|
| **代理地址** | `0xC0021e0849faDefB98761f40829009905Dbd8Ee8` |
| **代理类型** | TransparentUpgradeableProxy (ERC1967) |
| **实现地址** | `0x6d694ce971343626429f87ef05e0cd292e3f2f54` |
| **代理管理员初始所有者** | `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7` |
| **BscScan** | [查看代理](https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8) |

#### 质押实现

| 字段 | 值 |
|-------|-------|
| **实现地址** | `0x6d694ce971343626429f87ef05e0cd292e3f2f54` |
| **验证状态** | ❌ **未验证** |
| **余额** | 0 BNB |
| **创建者** | `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7` |
| **交易数** | 0 笔记录 |
| **BscScan** | [查看合约](https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54) |

#### ⚠️ 限制说明：
- ❌ **源代码未在 BscScan 验证** - 人类可读的 Solidity 代码未公开发布
- ❌ **函数无法读取** - 未验证源代码或发布 ABI，无法确认具体函数签名
- ⚠️ **交易历史显示 "Rebase" 方法** - 暗示存在 rebase/代币经济学机制，但具体逻辑未知
- ⚠️ **存在代理支持但无升级记录** - 实现可由管理员更改

#### 已知信息：
- 使用 ERC1967 透明可升级代理模式
- 代理管理员由 `0x8533e14caea7c622a1dc69b9eb5f0e47b79ce6a7` 控制
- 交易历史表明存在 `Rebase` 方法
- 推测处理 PRO 代币质押和奖励分发（未验证）

#### 源文件：
见 `contracts/Staking_Proxy/` 目录（仅代理基础设施）

#### 交易记录：
- 质押代理所有者：`0xD78D4a09E00a54ac9787ECbBeCA02791336C75b3`
- 交易 1：[交易](https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog)
- 交易 2：[交易](https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog)

---

### 4. 多签钱包（Gnosis Safe）

| 字段 | 值 |
|-------|-------|
| **合约地址** | `0x912008f7f56650bFcBa8102cdCD8ABD889769997` |
| **类型** | Gnosis Safe Multisig（Safe 代理） |
| **余额** | 0 BNB |
| **总交易数** | 10 笔 |
| **活跃期** | 2026 年 3 月 11 日 – 3 月 24 日 |
| **部署者** | `0x3AB5B452...3673b26d1` |
| **BscScan** | [查看钱包](https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997) |

#### 已知活动：
- 3 月 11 日收到 2 笔 0.01 BNB（约 $6.11）转账
- 内部交易显示向 `0xA4190d3e...409Be1cA7` 的出站转账
- 主要使用 `Exec Transaction` 方法（多签执行）
- 当前余额：0 BNB

#### ⚠️ 限制说明：
- ❌ **所有者未公开列出** - 需查询 Safe 合约的 `getOwners()` 函数
- ❌ **确认阈值未知** - 需查询 `getThreshold()` 函数
- ⚠️ 控制 PRO 代币、国库和质押系统的核心权限

---

## 📁 项目结构

```
Crypto-Dao-V3-Pro/
│
├── README.md                                         # 英文文档
├── README_CN.md                                      # 中文文档（本文档）
├── PROJECT_TREE.md                                   # 原始项目树
├── PROJECT_SUMMARY.md                                # 项目总结
├── proxy_admin                                       # 国库代理管理员信息
├── RBS_owner                                         # RBS 合约所有者信息
├── staking_proxy_owner                               # 质押代理所有者信息
│
├── contracts/                                        # 智能合约（有组织）
│   ├── PRO_Token/                                    # PRO 代币合约 ✅
│   │   ├── ProToken.sol                              # 主代币合约 ✅
│   │   ├── ERC20.sol                                 # OpenZeppelin ERC20
│   │   ├── IERC20.sol                                # ERC20 接口
│   │   ├── IERC20Metadata.sol                        # 元数据接口
│   │   ├── Ownable.sol                               # 所有权管理
│   │   ├── Context.sol                               # 上下文工具
│   │   ├── draft-IERC6093.sol                        # 错误标准
│   │   └── Settings.txt                              # 编译配置
│   │
│   ├── Treasury_Proxy/                               # 国库代理
│   │   ├── TransparentUpgradeableProxy.sol           # 代理合约
│   │   ├── ProxyAdmin.sol                            # 代理管理员
│   │   ├── ERC1967Proxy.sol                          # ERC1967 代理
│   │   └── ...（其他代理基础设施）
│   │
│   ├── Treasury_Implementation/                      # 国库逻辑实现
│   │   ├── Treasury.sol                              # CryptoTreasury 实现 ✅
│   │   ├── IERC20.sol                                # ERC20 接口
│   │   ├── SafeERC20.sol                             # SafeERC20 库
│   │   └── ...（其他依赖）
│   │
│   ├── Staking_Proxy/                                # 质押代理
│   │   ├── TransparentUpgradeableProxy.sol           # 代理合约
│   │   ├── ProxyAdmin.sol                            # 代理管理员
│   │   └── ...（其他代理基础设施）
│   │
│   └── Multisig_Wallet/                              # 多签钱包（空目录）
│
├── docs/                                             # 详细文档
│   ├── INDEX.md                                      # 文档索引导航
│   ├── ADDRESSES.md                                  # 完整地址注册表
│   ├── SECURITY_ANALYSIS.md                          # 安全分析与风险评估
│   └── VERIFICATION_GUIDE.md                         # BscScan 验证指南
│
└── （原始目录，保留供参考）
    ├── PRO0x8D65744527f55d0b2338350912d5C99A81ddF0e2/
    ├── Treasury0xf9074b5C035c961443373f78A6344e5Adc61d314/
    ├── Implementation0xD2B955d22c542EAF932A3cCB1960de3D75a3473B/
    ├── staking_proxy0xC0021e0849faDefB98761f40829009905Dbd8Ee8/
    └── safe_wallet0x912008f7f56650bFcBa8102cdCD8ABD889769997/
```

---

## 🔗 外部依赖（未验证）

以下合约/组件无法独立验证或定位：

| 组件 | 状态 | 说明 |
|-----------|--------|-------|
| **PancakeSwap 流动性池（targetPool）** | ❌ 无法验证 | PRO 代币的 `targetPool` 地址未公开披露。推测为 PancakeSwap V2 交易对。 |
| **债券计算器（Bond Calculator）** | ❌ 无法验证 | 国库中引用的 LP 代币估值合约。地址未知。 |
| **RBS 合约** | ✅ 已找到 | RBS 代理合约：`0xc2d8595fe8d904a8665059d68a6fa2467df09a13`，实现合约：`0x309c177f3ae5a4132427895ab5cd005f181adefa`（RBSControl） |
| **USD 稳定币** | ❌ 无法验证 | 国库接受的储备资产地址未知。 |
| **当前治理地址** | ❌ 无法验证 | PRO 代币的 `governance` 字段值未公开披露。 |
| **当前国库地址** | ❌ 无法验证 | PRO 代币的 `treasury` 字段值未公开披露。 |
| **白名单地址列表** | ❌ 无法验证 | 免税/免除限制的地址未公开披露。 |
| **角色管理者地址** | ❌ 无法验证 | 国库系统中各角色的授权管理者未披露。 |
| **质押实现逻辑** | ❌ 未验证 | 实现合约存在但源代码未在 BscScan 验证。 |

---

## 🛡️ 安全分析

### ✅ 积极指标：
1. **核心合约已验证**：PRO 代币和国库实现在 BscScan 上已验证
2. **可升级架构**：使用成熟的 OpenZeppelin TransparentUpgradeableProxy 模式
3. **多签治理**：核心权限通过 Gnosis Safe 控制
4. **基于角色的访问控制**：国库实现细粒度权限管理
5. **队列系统**：角色变更需要区块延迟以提高安全性

### ⚠️ 风险因素：
1. **质押合约未验证**：`0x6d69...2f54` 实现没有已验证的源代码
2. **社区警告**：多个 Twitter/X 账户将此项目与之前的项目（AKAS、OLY、LynkCoDAO）关联，据称是"循环"模式
3. **中心化风险**：所有者和治理角色具有重大控制权
4. **铸造能力**：国库可以无限制铸造 PRO 代币
5. **转账限制**：所有者可以禁用流动性池的转账
6. **税收可配置**：卖出税可调整至最高 30%
7. **空 pro-ecosystem 目录**：项目结构似乎不完整

### 🔒 建议：
1. **不要投入超过你能承受损失的资金**
2. **在 BscScan 上验证所有合约后再交互**
3. **监控多签钱包活动**
4. **检查最近的合约升级**
5. **查看交易历史是否有异常活动**
6. **交易前注意税收影响**

---

## 📊 市场数据

| 指标 | 值 |
|--------|-------|
| **当前价格** | ~$60.81 USD |
| **历史最高** | ~$60.83 USD |
| **市值** | ~$0（未验证） |
| **24h 交易量** | ~$160 万 |
| **持有者** | 140,900 |
| **总供应量** | 1,240,979.305198 PRO |

*数据来源：LiveCoinWatch、Birdeye、PancakeSwap。价格可能已过时。*

---

## 🔍 如何验证合约

### 第 1 步：访问 BscScan
前往 [https://bscscan.com](https://bscscan.com)

### 第 2 步：搜索合约地址
复制本文档中的任何合约地址并粘贴到搜索栏中。

### 第 3 步：查看源代码
- 点击 **Contract** 标签
- 查找绿色勾号（✅）表示已验证的代码
- 直接阅读 Solidity 源代码

### 第 4 步：读取合约数据
- 对于标准合约：点击 **Read Contract**
- 对于代理合约：点击 **Read as Proxy**
- 查看实时参数和状态

### 第 5 步：监控交易
- 点击 **Transactions** 查看交互历史
- 检查 **Internal Txns** 了解合约间调用
- 查看 **Token Transfers** 了解 BEP-20 转移

---

## ⚙️ 技术栈

| 组件 | 版本/详情 |
|-----------|----------------|
| **Solidity** | 0.8.30 |
| **EVM 版本** | Cancun / Prague |
| **框架** | OpenZeppelin Contracts & Upgradeable |
| **代理模式** | Transparent Upgradeable Proxy (ERC1967) |
| **区块链** | 币安智能链（BSC） |
| **优化器** | 已启用（200 次运行） |
| **IR 编译** | 已启用（viaIR） |
| **构建工具** | 可能为 Foundry（Settings 文件表明使用 Forge） |

---

## 📝 交易历史

### 关键交易：

| 描述 | 交易哈希 |
|-------------|------------------|
| RBS 所有者变更 | [0x73c3842...](https://bscscan.com/tx/0x73c38428fdf75ed3fe3a8bcf5c51aeb04144bd6a1e0f2af2c36191ae7f274b5c#eventlog) |
| 代理管理员交易 1 | [0x0e414ee...](https://bscscan.com/tx/0x0e414eeed70d947fea719af0fd6def68a2ba038103ca886b65103c8f607c886e) |
| 代理管理员交易 2 | [0xea04f20...](https://bscscan.com/tx/0xea04f2023b1dcc1264fd07ab983947c4784ccb3fb86b16de8c1162f6a037f2b1) |
| 质押代理交易 1 | [0x795be95...](https://bscscan.com/tx/0x795be955eab2da66e1e23c03d17e0e95639f29b28bda154330394c37ea8007fa#eventlog) |
| 质押代理交易 2 | [0x246bf6b...](https://bscscan.com/tx/0x246bf6bb3d18a761542563cce8dc152eaa9352a02335b26c5a6b853472fc7777#eventlog) |

---

## 🚨 重要说明

### 无法验证的内容：

1. ❌ **质押实现源代码**：未在 BscScan 发布
2. ❌ **PancakeSwap 配对地址**：targetPool 未公开披露
3. ❌ **债券计算器合约**：地址和逻辑未知
4. ❌ **USD 储备代币**：稳定币地址未知
5. ❌ **当前角色持有者**：国库授权角色的地址未披露
6. ❌ **治理参数**：当前治理和国库地址未公开可见
7. ❌ **项目团队**：开发者/团队身份匿名
8. ❌ **审计报告**：未发现安全审计
9. ❌ **官方文档**：未找到白皮书或技术文档

### 社区报告：

X/Twitter 上的多个来源将此项目与一系列先前项目关联：
- AKAS → OLY → LynkCoDAO → CryptoDAO V3 PRO

这些报告据称是一个"循环"模式。**这尚未被独立证实。** 所有声称均来自社区成员，应仔细评估。

---

## 📞 资源链接

- **BscScan**：[https://bscscan.com](https://bscscan.com)
- **PancakeSwap**：[https://pancakeswap.finance](https://pancakeswap.finance)
- **PRO 代币 on Birdeye**：[查看](https://birdeye.so/bsc/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2)
- **PRO 代币 on LiveCoinWatch**：[查看](https://www.livecoinwatch.com/price/ProToken-___________PRO)
- **PRO 代币 on PancakeSwap**：[查看](https://pancakeswap.finance/info/bsc/tokens/0x8d65744527f55d0b2338350912d5c99a81ddf0e2)

---

## 📜 许可证

智能合约使用 MIT 许可证（如已验证合约中指定）。本文档仅供参考。

---

## ⚖️ 免责声明

本文档基于链上数据、已验证的智能合约代码和公开可用的信息汇编而成。这不构成财务建议。

**关键点：**
- 在交互之前始终在 BscScan 上验证合约
- 智能合约可升级（代理架构）
- 所有者/治理角色具有重大控制权
- 存在据称与先前项目关联的社区报告
- 未发现审计报告
- 所有投资都有风险；永远不要投入你无法承受损失的资金

---

*最后更新：2026 年 4 月 8 日*  
*数据来源：BscScan、LiveCoinWatch、Birdeye、PancakeSwap、链上 RPC 查询*  
*文档状态：**全面** - 包含所有可验证数据，已记录限制说明*
