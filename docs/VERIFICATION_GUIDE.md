# 合约验证指南

> 在 BscScan 上逐步验证本项目中所有合约的指南。

---

## 快速开始

1. 访问：**https://bscscan.com**
2. 复制本项目中的任何合约地址
3. 粘贴到 BscScan 搜索栏
4. 查看合约详情

---

## 验证每个合约

### 1. PRO 代币

**地址**: `0x8D65744527f55d0b2338350912d5C99A81ddF0e2`

#### 步骤：
1. 前往 https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2
2. 验证绿色勾号 ✅（已验证合约）
3. 点击 **Contract** 标签
4. 点击 **Code** 阅读 Solidity 源代码
5. 点击 **Read Contract** 查看实时参数
6. 检查这些关键值：
   - `sellRatio()` - 当前卖出税（基点）
   - `governance()` - 治理地址
   - `treasury()` - 国库地址
   - `targetPool()` - 流动性池地址
   - `transferStatus()` - 转账启用标志
   - `feeReceiver()` - 费用收集地址

#### 需要注意：
- ✅ 编译器版本匹配（v0.8.30）
- ✅ 启用优化（200 次运行）
- ✅ 精确匹配状态
- ⚠️ 任何最近的代码更改
- ⚠️ 异常的参数值

---

### 2. 国库代理

**地址**: `0xf9074b5C035c961443373f78A6344e5Adc61d314`

#### 步骤：
1. 前往 https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314
2. 点击 **Contract** 标签
3. 注意这是一个**代理**合约
4. 点击 **Read as Proxy**
5. 检查：
   - 实现地址
   - 管理员地址
   - 最近的升级交易

#### 需要注意：
- ✅ 代理模式实现
- ✅ 已知的实现地址
- ⚠️ 最近的代理升级
- ⚠️ 管理员变更

---

### 3. 国库实现（CryptoTreasury）

**地址**: `0xD2B955d22c542EAF932A3cCB1960de3D75a3473B`

#### 步骤：
1. 前往 https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B
2. 验证绿色勾号 ✅（已验证合约）
3. 点击 **Contract** 标签
4. 点击 **Code** 阅读源代码
5. 点击 **Read Contract** 查看参数
6. 检查这些关键值：
   - `proToken()` - 应为 PRO 代币地址
   - `totalReserves()` - 总储备价值
   - `usd()` - 稳定币储备地址
   - `rbs()` - RBS 合约地址
   - `blocksNeededForQueue()` - 队列延迟
   - `owner()` - 合约所有者

#### 需要注意：
- ✅ 已验证源代码
- ✅ MIT 许可证
- ✅ 预期参数值
- ⚠️ `reserveTokens[]` - 已批准的储备资产
- ⚠️ `liquidityTokens[]` - 已批准的 LP 代币
- ⚠️ 角色管理者地址

---

### 4. 质押代理

**地址**: `0xC0021e0849faDefB98761f40829009905Dbd8Ee8`

#### 步骤：
1. 前往 https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8
2. 点击 **Contract** 标签
3. 注意这是一个**代理**合约
4. 点击 **Read as Proxy**
5. 检查实现地址
6. 监控升级

#### 需要注意：
- ✅ 代理模式
- ⚠️ 实现未验证
- ⚠️ 没有记录的升级
- ⚠️ 未知功能

---

### 5. 质押实现 ⚠️

**地址**: `0x6d694ce971343626429f87ef05e0cd292e3f2f54`

#### 步骤：
1. 前往 https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54
2. 注意：**没有绿色勾号** ❌
3. 源代码**未验证**
4. 只有字节码可用
5. 无法读取函数或逻辑

#### ⚠️ 警告：
- **在代码验证之前请勿交互**
- 无法审计功能
- 未知的奖励机制
- 潜在风险

#### 你可以检查：
- 余额（当前 0 BNB）
- 交易数（当前 0）
- 创建者地址
- 字节码（人类不可读）

---

### 6. 多签钱包（Gnosis Safe）

**地址**: `0x912008f7f56650bFcBa8102cdCD8ABD889769997`

#### 步骤：
1. 前往 https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997
2. 点击 **Contract** 标签
3. 点击 **Read Contract**
4. 查询这些函数（如果可用）：
   - `getOwners()` - 所有者地址列表
   - `getThreshold()` - 所需确认数
   - `nonce()` - 交易计数

#### 需要注意：
- ✅ Safe 合约模式
- ⚠️ 所有者默认未公开列出
- ⚠️ 阈值未知
- 交易历史
- 内部交易

---

## 理解代理架构

### 什么是代理？

代理合约将**存储**与**逻辑**分离：
- **代理**: 持有状态并委托调用
- **实现**: 包含实际业务逻辑
- **管理员**: 可以升级实现

### 为什么要使用代理？

1. **可升级性**: 可以在不丢失状态的情况下更改逻辑
2. **Gas 效率**: 用户与相同地址交互
3. **Bug 修复**: 可以修补漏洞

### 代理的风险

1. **管理员控制**: 管理员可以更改实现
2. **隐藏逻辑**: 新的实现可能是恶意的
3. **需要信任**: 必须信任当前和未来的实现

### 如何监控

1. 监控 `upgradeToAndCall` 交易
2. 检查实现地址变更
3. 升级后审查新的实现代码
4. 监控管理员地址活动

---

## 读取合约数据

### 需要监控的关键指标

#### PRO 代币
```
sellRatio()        → 当前卖出税（基点）
transferStatus()   → 转账已启用？
targetPool()       → 流动性池地址
governance()       → 治理地址
treasury()         → 国库地址
```

#### 国库
```
totalReserves()    → 总储备价值
proToken()         → PRO 代币地址
supplied()         → PRO 总供应
excessReserves()   → 可用于奖励
owner()            → 合约所有者
```

### 理解基点

- 1 基点 = 0.01%
- 100 = 1%
- 300 = 3%（默认卖出税）
- 3000 = 30%（最大卖出税）
- 500 = 5%（最大池燃烧）

---

## 常见验证检查

### ✅ 好的迹象
- [x] BscScan 上的绿色勾号
- [x] "精确匹配"状态
- [x] Solidity 源代码可读
- [x] 使用 OpenZeppelin 库
- [x] 合理的编译器版本
- [x] 启用优化
- [x] 活跃的交易历史

### ❌ 危险信号
- [ ] 没有验证（没有绿色勾号）
- [ ] 只有字节码可用
- [ ] 无法读取函数
- [ ] 非常新的合约
- [ ] 没有交易
- [ ] 可疑的创建者
- [ ] 异常的编译器设置

---

## 监控工具

### BscScan 功能
1. **Watchlist**: 添加合约进行监控
2. **Alerts**: 交易邮件通知
3. **API**: 程序化访问数据
4. **Token Tracker**: 监控代币持有

### 外部工具
- **Birdeye**: https://birdeye.so（价格、交易量、持有者）
- **PancakeSwap**: https://pancakeswap.finance（交易、流动性）
- **DeFiLlama**: https://defillama.com（TVL 追踪）

---

## 如果发现问题该怎么办

### 如果合约未验证
1. 不要与合约交互
2. 向团队请求验证
3. 在社区警告他人
4. 如果可疑，向 BscScan 报告

### 如果发现可疑活动
1. 记录交易哈希
2. 截图
3. 向社区报告
4. 联系 BscScan 支持

### 如果参数更改
1. 注意更改的内容
2. 检查谁发起的
3. 评估影响
4. 决定是否继续使用

---

## 快速参考

| 合约 | 状态 | BscScan 链接 |
|----------|--------|--------------|
| PRO 代币 | ✅ 已验证 | [链接](https://bscscan.com/token/0x8D65744527f55d0b2338350912d5C99A81ddF0e2) |
| 国库代理 | ✅ 已部署 | [链接](https://bscscan.com/address/0xf9074b5C035c961443373f78A6344e5Adc61d314) |
| 国库实现 | ✅ 已验证 | [链接](https://bscscan.com/address/0xD2B955d22c542EAF932A3cCB1960de3D75a3473B) |
| 质押代理 | ✅ 已部署 | [链接](https://bscscan.com/address/0xC0021e0849faDefB98761f40829009905Dbd8Ee8) |
| 质押实现 | ❌ 未验证 | [链接](https://bscscan.com/address/0x6d694ce971343626429f87ef05e0cd292e3f2f54) |
| 多签 | ✅ 已部署 | [链接](https://bscscan.com/address/0x912008f7f56650bFcBa8102cdCD8ABD889769997) |

---

## 其他资源

- **BscScan 指南**: https://bscscan.com/label/cloud
- **OpenZeppelin 文档**: https://docs.openzeppelin.com/contracts/
- **代理模式**: https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
- **智能合约验证**: https://ethereum.org/en/developers/docs/smart-contracts/verifying/

---

*最后更新：2026 年 4 月 8 日*
*状态：完整指南*
