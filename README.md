# 🖥️ PC Hardware Master (电脑硬件与系统工程大师)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%20Windows%2011-blue.svg)](https://microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B-green.svg)](https://microsoft.com/powershell)
[![Dependency](https://img.shields.io/badge/Dependencies-Zero%20(Native)-success.svg)](#)
[![Dual-Mode](https://img.shields.io/badge/Mode-Agent%20Skill%20%7C%20Standalone%20CLI-purple.svg)](#)

> **专为 Windows 10 / 11 打造的工业级 PC 硬件实时诊断、健康体检与微卡顿消除工具箱。**  
> 既是可接入各大主流 AI 编程助手的原生 **Agent Skill**，也是人类用户在终端中即开即用的 **零依赖 CLI 工具**。

---

## 📖 项目简介 (Overview)

在日常使用和游戏、生产力场景中，PC 往往会出现各种难以定位的疑难杂症：游戏掉帧与 1% Low 崩塌、Wi-Fi 周期性跳 Ping 抖动、双显卡 MUX 混合输出损耗、MPO 多平面叠加花屏、DPC 中断延迟爆音，或是“优化软件”暴力清内存导致的严重二次卡顿。

`pc-hardware-master` 致力于用**底层工程视角与实地探测数据**解决这些问题。它杜绝“凭感觉盲猜”和“玄学优化”，通过纯原生 PowerShell 探针穿透底层硬件拓扑与操作系统内核，提供量化评估、只读诊断、精准调优及 100% 毫秒级桌面回滚守护。

---

## 🎯 核心解决痛点 (Problems Solved)

| 典型痛点场景 | 传统做法 / 常见误区 | 本项目的工程解法 |
| :--- | :--- | :--- |
| **电竞掉帧 / 1% Low 崩塌** | 盲目重装系统、加装“内存清理大师”（反而导致工作集被清空引发缺页中断硬卡死） | 专项嗅探 GameDVR 静默录屏抢占、高刷新率对齐、GPU 着色器缓存体积与内存常驻杀手 |
| **Wi-Fi 周期性跳 Ping / 丢包** | 以为是路由器损坏或电信运营商断网 | 动态定位无线网卡，关闭后台定位与后台静默网络漫游扫描，锁定信道激进阈值 |
| **笔记本游戏性能衰减** | 误以为显卡过热缩水 | 嗅探内屏直连链路与 DCH 驱动态势，识别 Optimus 混合输出带宽瓶颈 |
| **开发环境被流氓优化搞崩** | 普通优化脚本粗暴清除环境变量、删除缓存、停用 Docker/WSL 虚拟网卡 | **严格锁定开发者安全红线**：绝不触碰 `PATH`、包管理器缓存与虚拟网络适配器 |
| **调优后后悔无法复原** | 注册表被乱改改不回来，只能被迫重装或还原断点 | **调优与回滚 100% 对称生成**：调优时同步在桌面输出 UTF-8 纯净批处理，一键无损秒还原 |

---

## 🌟 核心特性 (Key Features)

- ⚡ **零外部依赖 (Zero-Dependency)**：纯原生 PowerShell 5.1+ 编写，调用底层 CIM / WMI 与注册表原生接口，无需安装 Python、Node.js 或任何第三方库。
- 🔍 **只读探针先行 (Read-Only Probing)**：默认绝不擅自更改系统设置。先实地抓取真实硬件拓扑、供电、时钟、中断与显示链路，出具量化数据。
- 💯 **100 分制综合健康评分**：涵盖 8 大子系统（供电计划、高刷显示、SMART 健康、TRIM 状态、游戏模式、DVR、鼠标线性输入、着色器缓存），自动汇总达标项与改进建议。
- 🧩 **全品类硬件自适应**：智能区分台式机、游戏本、轻薄本、MiniPC 及掌机；自动滤除 UPS/铅酸应急电源避免电池误报；自适应 Intel/AMD CPU 架构与 Intel/AMD/NVIDIA 显示拓扑。
- 🛡️ **开发者环境专属护航**：自动识别 Node/Python/Go/Rust 开发环境，严格绕开全局缓存目录与虚拟网络适配器。
- 🔄 **桌面一键极速回滚**：无 BOM 纯净批处理，支持提权守护与控制台对齐，确保优化前与优化后系统的双向确定性。

---

## 🚀 快速上手 (Quick Start)

### 方式 1：人类用户独立使用 (无需 AI，原生终端即跑)

克隆或下载本仓库至本地，在管理员 PowerShell 窗口中运行对应脚本：

```powershell
# 1. 运行 100 分制电脑综合健康深度体检 (只读安全，耗时 ~2秒)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/run-full-healthcheck.ps1"

# 2. 嗅探全景硬件画像与显示/网络拓扑 (只读安全)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/probe-universal-hardware.ps1"

# 3. 排查电竞微卡顿与 1% Low 掉帧瓶颈 (只读安全)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/probe-stutter-bottlenecks.ps1"

# 4. 生成桌面调优脚本与配套回滚脚本 (将在当前用户桌面生成两个 .bat 脚本)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/generate-safe-optimization.ps1"
```

> **回滚提示**：若需撤销优化，随时双击桌面上的 `一键恢复系统与网络默认值.bat`，即可一键还原默认配置。

---

### 方式 2：作为 Agent Skill 接入 AI 助手

本项目原生兼容 [Agent Skills 规范](https://github.com/agentskills)。可直接嵌入 Claude Desktop、Antigravity、OpenCode、Codex、Cherry Studio 等 AI 编程智能体。

#### 安装路径参考：

| 平台 / 工具 | 部署目录 |
| :--- | :--- |
| **全局 Agent 技能目录** | `~/.agents/skills/pc-hardware-master` |
| **Claude Desktop** | `~/.claude/skills/pc-hardware-master` |
| **当前项目级技能目录** | `<your-project>/.agents/skills/pc-hardware-master` |

#### 自然语言即刻唤醒：
安装后，AI 智能体将在遇到以下诉求时自动调取本技能：
- *“帮我体检一下这台电脑的健康状态”*
- *“玩无畏契约/CS2 经常微卡顿掉帧，帮我排查原因”*
- *“Wi-Fi 隔几十秒就跳 Ping 一次，怎么解决？”*
- *“帮我生成一套安全低延迟的调优方案，并附带回滚脚本”*

---

## 🛠️ 脚本武器库 (Scripts Arsenal)

本项目在 `scripts/` 目录中内置 6 大工业级自动化工程脚本：

| 脚本名称 | 运行权限 | 核心职责与产出物 |
| :--- | :--- | :--- |
| [`run-full-healthcheck.ps1`](scripts/run-full-healthcheck.ps1) | 用户 / 管理员 | **综合全身体检总控**：扫描 8 大维度，计算 0-100 健康得分，输出包含硬件拓扑、达标项与待优化项的 Markdown 综合体检报告。 |
| [`probe-universal-hardware.ps1`](scripts/probe-universal-hardware.ps1) | 用户 / 管理员 | **全硬件指纹自适应嗅探**：探测台式机/笔记本形态、CPU 异构大小核架构、GPU 活动状态、屏幕分辨率与刷新率、物理网络接口。 |
| [`probe-stutter-bottlenecks.ps1`](scripts/probe-stutter-bottlenecks.ps1) | 用户 / 管理员 | **电竞微卡顿与延迟专项探针**：探测 Windows 游戏模式、后台 GameDVR 状态、内存杀手残留、DirectX 着色器缓存占用及网络节流索引。 |
| [`probe-hardware-profile.ps1`](scripts/probe-hardware-profile.ps1) | 用户 / 管理员 | **基础硬件画像与拓扑探针**：抓取主板型号、物理内存插槽数/频率、系统架构与显示适配器驱动版本。 |
| [`generate-safe-optimization.ps1`](scripts/generate-safe-optimization.ps1) | 用户 / 管理员 | **桌面一键安全优化生成器**：在用户桌面生成 `一键安全深度调优.bat`（含卓越性能电源切换、网络节流解除、Wi-Fi 抗跳 Ping），**并自动同步调用生成回滚脚本**。 |
| [`generate-rollback-helper.ps1`](scripts/generate-rollback-helper.ps1) | 用户 / 管理员 | **桌面一键极速回滚生成器**：在用户桌面生成 `一键恢复系统与网络默认值.bat`，将电源、多媒体节流、网络扫描参数 100% 还原至出厂默认值。 |

---

## 📊 100 分制体检报告示例 (Sample Output)

执行 `run-full-healthcheck.ps1` 后的控制台真实输出片段：

```text
# 🖥️ Windows PC 综合性能与健康深度体检报告
- 体检时间：2026-09-24 20:53:13
- 综合健康评分：83 / 100 【良好 (Good)】
- 机型态势：Dell Inc. (Dell G15 5530) · 笔记本
- 硬件核心：13th Gen Intel(R) Core(TM) i5-13450HX (Intel_Hybrid_P_and_E_Core)
- 显示链路：Intel(R) UHD Graphics · 1920x1080 @ 165Hz 【Optimus混合输出】
- 内存与空间：物理内存已用 7.7G / 总计 15.7G · C 盘可用 59.7G

🟢 达标与已调优项 (10 项)
- [x] 电源调度：已激活「卓越性能」低延迟电源方案
- [x] 屏幕刷新率：当前运行在高刷新率模式 (165Hz)
- [x] 内存环境：未发现暴力清内存软件，运行纯净
- [x] 固态健康：所有物理磁盘 S.M.A.R.T. 健康状态均正常 (Healthy)
- [x] 固态寿命：TRIM 垃圾回收功能已正常激活
- [x] Windows 游戏模式：已启用 (进程调度向游戏倾斜)
- [x] 后台录屏：Xbox Game DVR 已关闭 (杜绝静默编码抢占显卡)
- [x] 鼠标指针输入：系统级非线性鼠标加速度已关闭 (1:1 纯净线性跟手)
- [x] 着色器缓存：体积健康 (0.13MB)

🟡 推荐优化提升项 (3 项)
- [ ] 在显卡控制中心中开启「仅限独显 / 独显直连」
- [ ] 关闭 NetworkThrottlingIndex 并将 SystemResponsiveness 调优为 0
- [ ] 进入主板 BIOS 开启 Secure Boot (安全启动)

🛡️ 开发者环境安全护航状态
- 环境变量 (PATH)：已锁死，绝不修改系统 PATH
- 开发者缓存 (npm/pip/uv)：已隔离保护，绝不误删
- 虚拟网络 (Docker/WSL/VPN)：完全绕行，仅作用于物理以太网卡与 Wi-Fi 芯片
- 极速回滚机制：随时可通过桌面回滚脚本毫秒级还原
```

---

## 🛡️ 开发者安全边界与工程规范 (Safety Guarantees)

1. **开发者四不碰 (Dev Guardrails)**：
   - 🚫 **绝对禁止修改环境变量**：不增删改 `PATH`、`JAVA_HOME`、`PYTHONPATH` 等任何系统或用户环境变量；
   - 🚫 **绝对禁止扫描/清理开发缓存**：绕开 `~/.npm`、`~/.cache`、`~/.cargo`、`venv`、`node_modules` 等开发目录；
   - 🚫 **绝对禁止干扰虚拟网卡**：网络优化逻辑过滤 `vEthernet`、`WSL`、`Docker`、`Tailscale` 等虚拟网卡，仅针对物理硬件网卡；
   - 🚫 **绝对禁止关闭核心系统服务**：不触碰 Windows Update、Defender 核心防御、RPC、DWM 等关键基础服务。

2. **工程实现细节 (Engineering Details)**：
   - **BOM-Free UTF-8 批处理生成**：通过 .NET `[System.Text.UTF8Encoding]($false)` 原生输出批处理脚本，彻底解决 Windows `cmd.exe` 在解析带 BOM 文件时出现的 `'﻿@echo' 不是内部或外部命令` 语法崩溃；
   - **动态网卡枚举匹配**：摒弃脆弱的 `"Wi-Fi"` 硬编码名称，改用 `PhysicalAdapter = True` 与 `NetConnectionStatus = 2` 结合驱动描述动态定位真实网卡；
   - **严谨设备形态加权判断**：支持根据主板底盘类型代码（ChassisTypes）与电源管理子系统精确识别机型形态，自动剥离 UPS 备用电源。

---

## 📁 目录结构 (Directory Tree)

```text
pc-hardware-master/
├── SKILL.md            # Agent 规范核心定义与交互工作流
├── README.md           # 项目开源说明文档 (本项目)
├── LICENSE             # MIT 开源许可证
├── scripts/            # 自动化探针与脚本武器库 (6 个原生 PowerShell 脚本)
│   ├── run-full-healthcheck.ps1
│   ├── probe-universal-hardware.ps1
│   ├── probe-stutter-bottlenecks.ps1
│   ├── probe-hardware-profile.ps1
│   ├── generate-safe-optimization.ps1
│   └── generate-rollback-helper.ps1
└── references/         # 31 卷领域底层工程手册 (供 Agent 推理与知识查阅)
```

---

## 📄 开源许可证 (License)

本项目遵循 [MIT License](LICENSE) 协议开源。
