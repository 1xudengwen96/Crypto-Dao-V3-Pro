智能合约查询与验证指南 / Smart Contract Verification Guide

欢迎来到我们的智能合约查询指南！为了保证项目的绝对透明与安全，我们公开了所有的核心智能合约地址。本指南将帮助任何人（即使您没有编程基础）独立地在区块链浏览器上查询、验证并监控我们的合约数据。

Welcome to our Smart Contract Verification Guide! To ensure absolute transparency and security, we have made all our core smart contract addresses public. This guide will help anyone (even without programming experience) to independently query, verify, and monitor our contracts on the block explorer.

📚 1. 核心合约地址总览 / Core Contract Addresses

以下是系统核心组件的合约地址列表。您可以复制这些地址并在区块链浏览器（如 BscScan 或 Etherscan）中搜索。

Below is the list of core component contract addresses. You can copy these addresses and search them on the block explorer (like BscScan or Etherscan).

组件名称 (Component)

合约地址 (Contract Address)

说明 (Description)

PRO 代币 (PRO Token)

0x8D65744527f55d0b2338350912d5C99A81ddF0e2

核心资产合约，包含转账与税收逻辑 / The core asset contract containing transfer and tax logic.

多签钱包 (Safe Multisig)

0x912008f7f56650bFcBa8102cdCD8ABD889769997

管理最高权限，保护系统免受单点故障风险 / Manages admin privileges, protecting the system from single points of failure.

国库代理 (Treasury Proxy)

0xf9074b5C035c961443373f78A6344e5Adc61d314

资金池入口，用户交互的主要国库地址 / The main Treasury address users interact with.

国库逻辑 (Treasury Impl.)

0xD2B955d22c542EAF932A3cCB1960de3D75a3473B

国库的底层业务代码实现 / The underlying business logic implementation of the Treasury.

质押代理 (Staking Proxy)

0xC0021e0849faDefB98761f40829009905Dbd8Ee8

用户质押 PRO 代币以获取奖励的入口 / The entry point for users to stake PRO tokens for rewards.

💡 提示 (Note)：带有 "Proxy (代理)" 字样的合约意味着它是可升级的。您的资金交互都在 Proxy 地址进行。
Contracts labeled "Proxy" mean they are upgradable. Your asset interactions always happen at the Proxy address.

🔍 2. 如何独立查询合约信息 / How to Verify Contracts Independently

任何人都可以通过以下简单的步骤来核实合约的真实状态和代码：

Anyone can verify the true state and code of the contracts through these simple steps:

步骤 1：打开区块链浏览器 / Step 1: Open Block Explorer

访问官方区块链浏览器（如 BscScan.com 或 Etherscan.io）。

Visit the official block explorer (e.g., BscScan.com or Etherscan.io).

步骤 2：搜索合约地址 / Step 2: Search the Address

将上方表格中的任意合约地址复制，并粘贴到浏览器顶部的搜索框中，点击回车。

Copy any Contract Address from the table above, paste it into the search bar at the top of the explorer, and press Enter.

步骤 3：查看源代码 / Step 3: View Source Code

点击页面下方的 Contract (合约) 标签页。

只要代码旁边有一个绿色的打勾标志 (✅)，就说明代码已经100%开源并经过了验证。您可以直接阅读所有的 Solidity 源码。

Click on the Contract tab in the middle of the page.

A green checkmark (✅) next to "Contract" means the code is 100% open-source and verified. You can read all the underlying Solidity code right there.

🛠 3. 常见查询指引 / Common Query Guides

A. 如何查看多签钱包的余额？ / How to check Multisig Balance?

多签钱包 (0x912008f7f56650bFcBa8102cdCD8ABD889769997) 控制着系统命脉。

直接在浏览器搜索该地址。

点击 Token Tracker 下拉菜单，即可看到多签钱包内持有的所有资产情况。

The Multisig wallet controls the system's privileges.

Search the address on the block explorer.

Click the Token Tracker dropdown menu to see all assets held securely in the multisig wallet.

B. 如何读取“代理(Proxy)”合约的数据？ / How to read "Proxy" contracts?

对于国库 (Treasury Proxy) 和 质押 (Staking Proxy)，因为采用了安全的代理架构：

搜索 Proxy 合约地址。

点击 Contract 标签，然后点击 Read as Proxy (作为代理读取)。

您将能看到所有的系统参数（例如：当前的国库储备量、奖励分配比例等）。

For Treasury and Staking, because they use a secure proxy architecture:

Search the Proxy contract address.

Click the Contract tab, then click Read as Proxy.

You will be able to see all live system parameters (e.g., current treasury reserves, reward distribution rates, etc.).

C. 如何查询 PRO 的燃烧与税收设置？ / How to check PRO Tax & Burn settings?

搜索 PRO 代币地址 (0x8D...F0e2)。

点击 Contract -> Read Contract (读取合约)。

找到名为 burnFee 或类似带有 Fee/Rate 的函数，点击即可看到当前的税收百分比设定。

Search the PRO token address.

Go to Contract -> Read Contract.

Look for functions named like burnFee or containing Fee/Rate to see the transparent tax percentage setups.

🛡 4. 我们的安全承诺 / Our Security Commitment

我们坚信 Don't Trust, Verify (不要轻信，去验证)。

核心权限已移交至 Gnosis Safe 多签钱包。

核心逻辑全部在链上开源验证。

如果您在查询过程中发现任何疑问，欢迎在社区中公开提出！

We strongly believe in "Don't Trust, Verify".

Core privileges are secured by a Gnosis Safe multisig wallet.

Core logic is fully open-source and verified on-chain.

If you have any questions while verifying, please ask publicly in our community!