# 🖥️ PC Hardware Master (电脑硬件与系统工程大师)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%20Windows%2011-blue.svg)](https://microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell%205.1%2B-blue.svg)](https://microsoft.com/powershell)

> 专为 Windows 10 / 11 打造的 PC 硬件实时诊断、健康体检与微卡顿消除工具箱。  
> 既是可接入主流 AI 编程助手的 Agent Skill，也是在终端中即开即用的独立 CLI 工具。

---

## 项目简介 (Overview)

在日常使用、电竞游戏与生产力场景中，PC 往往会出现各种难以定位的性能问题：游戏掉帧与 1% Low 崩塌、Wi-Fi 周期性跳 Ping 抖动、双显卡 MUX 混合输出损耗、MPO 多平面叠加花屏、DPC 中断延迟爆音，或是“优化软件”暴力清内存导致的严重二次卡顿。

`pc-hardware-master` 基于底层工程视角与实地探测数据解决上述问题。项目基于原生 PowerShell 探针穿透底层硬件拓扑与操作系统内核，提供量化评估、只读诊断、精准调优及 100% 毫秒级桌面回滚支持。

---

## 核心解决痛点 (Problems Solved)

| 痛点场景 | 常见误区 | 本项目的工程解法 |
| :--- | :--- | :--- |
| 电竞掉帧 / 1% Low 崩塌 | 盲目重装系统、加装第三方“内存清理”工具（清空工作集反而引发缺页硬中断卡死） | 专项嗅探 GameDVR 静默录屏抢占、高刷新率对齐、GPU 着色器缓存与常驻进程 |
| Wi-Fi 周期性跳 Ping / 丢包 | 误判为路由器故障或运营商网络问题 | 动态匹配物理无线网卡，关闭后台定位与静默漫游扫描，锁定信道漫游阈值 |
| 笔记本游戏性能衰减 | 误以为显卡过热缩水 | 嗅探内屏直连链路与 DCH 驱动状态，识别 Optimus 混合输出带宽损耗 |
| 开发环境被过度优化破坏 | 粗暴修改 PATH、清理缓存、停用 WSL/Docker 虚拟网卡 | 严格锁定开发者安全红线：不触碰 PATH、包管理器缓存与虚拟网络适配器 |
| 调优后无法复原 | 注册表改动不可逆，被迫重装系统 | 调优与回滚 100% 对称生成：调优时同步在桌面输出纯净批处理，一键无损还原 |

---

## 核心特性 (Key Features)

- **零外部依赖 (Zero-Dependency)**：纯原生 PowerShell 5.1+ 编写，调用底层 CIM / WMI 与注册表原生接口，无需安装 Python、Node.js 或任何第三方运行时。
- **只读探针先行 (Read-Only Probing)**：默认不擅自更改系统设置。先实地抓取硬件拓扑、供电、时钟、中断与显示链路，出具量化数据。
- **100 分制综合健康评分**：涵盖供电计划、高刷显示、SMART 健康、TRIM 状态、游戏模式、DVR、鼠标线性输入、着色器缓存等 8 大子系统，自动汇总达标项与改进建议。
- **全品类硬件自适应**：智能区分台式机、游戏本、轻薄本、MiniPC 及掌机；自动滤除 UPS/铅酸应急电源避免电池误报；自适应 Intel/AMD 架构与核显/独显显示拓扑。
- **开发者环境专属护航**：识别开发环境，严格绕开全局缓存目录与虚拟网络适配器。
- **桌面一键极速回滚**：无 BOM 纯净批处理，支持提权守护与控制台对齐，确保优化前与优化后系统的双向确定性。

---

## 🚀 快速上手 (Quick Start)

### 方式 1：终端独立使用 (无需 AI，原生 PowerShell)

在管理员 PowerShell 窗口中运行对应脚本：

```powershell
# 1. 运行 100 分制电脑综合健康深度体检 (只读安全，耗时约 2 秒)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/run-full-healthcheck.ps1"

# 2. 嗅探全景硬件画像与显示/网络拓扑 (只读安全)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/probe-universal-hardware.ps1"

# 3. 排查电竞微卡顿与 1% Low 掉帧瓶颈 (只读安全)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/probe-stutter-bottlenecks.ps1"

# 4. 生成桌面调优脚本与配套回滚脚本 (将在桌面生成调优与回滚 .bat)
powershell -NoProfile -ExecutionPolicy Bypass -File "scripts/generate-safe-optimization.ps1"
```

回滚说明：若需撤销优化，随时运行桌面上的 `一键恢复系统与网络默认值.bat` 即可还原配置。

---

### 方式 2：作为 Agent Skill 接入 AI 助手

本项目兼容 Agent Skills 规范，可直接放入主流 AI 助手的技能目录：

| 工具 / 平台 | 部署路径 |
| :--- | :--- |
| 全局 Agent 技能目录 | `~/.agents/skills/pc-hardware-master` |
| Claude Desktop | `~/.claude/skills/pc-hardware-master` |
| 项目级技能目录 | `<your-project>/.agents/skills/pc-hardware-master` |

自然语言触发示例：
- “帮我体检一下这台电脑的健康状态”
- “玩无畏契约/CS2 经常微卡顿掉帧，排查原因”
- “Wi-Fi 隔几十秒就跳 Ping 一次，怎么解决”
- “生成一套安全低延迟的调优方案，并附带回滚脚本”

---

## 🛠️ 脚本工具清单 (Scripts Arsenal)

项目在 `scripts/` 目录内置 6 个自动化工程脚本：

| 脚本名称 | 权限要求 | 核心职责与产出物 |
| :--- | :--- | :--- |
| [`run-full-healthcheck.ps1`](scripts/run-full-healthcheck.ps1) | 用户 / 管理员 | 综合健康体检总控：扫描 8 大维度，计算 0-100 健康得分，输出 Markdown 综合体检报告。 |
| [`probe-universal-hardware.ps1`](scripts/probe-universal-hardware.ps1) | 用户 / 管理员 | 全硬件指纹自适应嗅探：探测台式机/笔记本形态、CPU 大小核架构、GPU 状态、屏幕分辨率与刷新率、物理网络接口。 |
| [`probe-stutter-bottlenecks.ps1`](scripts/probe-stutter-bottlenecks.ps1) | 用户 / 管理员 | 电竞微卡顿专项探针：探测游戏模式、后台 GameDVR 状态、内存驻留干扰、DirectX 着色器缓存占用与网络节流索引。 |
| [`probe-hardware-profile.ps1`](scripts/probe-hardware-profile.ps1) | 用户 / 管理员 | 基础硬件画像与拓扑探针：抓取主板型号、物理内存插槽数/频率、系统架构与显卡驱动版本。 |
| [`generate-safe-optimization.ps1`](scripts/generate-safe-optimization.ps1) | 用户 / 管理员 | 桌面一键安全优化生成器：在桌面生成 `一键安全深度调优.bat`，并自动调用生成回滚脚本。 |
| [`generate-rollback-helper.ps1`](scripts/generate-rollback-helper.ps1) | 用户 / 管理员 | 桌面一键极速回滚生成器：在桌面生成 `一键恢复系统与网络默认值.bat`，将电源、多媒体节流、网络扫描参数还原至出厂默认值。 |

---

## 100 分制体检报告示例 (Sample Output)

运行 `run-full-healthcheck.ps1` 后的控制台输出示例：

```text
# Windows PC 综合性能与健康深度体检报告
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

### 1. 开发者与用户环境五不碰原则

- **禁止修改环境变量**：不增删改 `PATH`、`JAVA_HOME`、`PYTHONPATH` 等系统或用户环境变量；
- **禁止扫描/清理开发缓存**：绕开 `~/.npm`、`~/.cache`、`~/.cargo`、`venv`、`node_modules` 等开发目录；
- **禁止干扰虚拟网卡**：网络优化逻辑过滤 `vEthernet`、`WSL`、`Docker`、`Tailscale` 等虚拟网卡，仅针对物理硬件网卡；
- **禁止关闭核心系统服务**：不触碰 Windows Update、Defender 核心防御、RPC、DWM 等关键基础服务；
- **禁止擅自关闭用户运行中软件**：严禁调用 `Stop-Process` 或 `taskkill` 杀除前后台软件。排查到疑似卡顿进程时，必须详细向用户介绍软件用途、解释性能冲突根因，并等待用户明确批准后方可处置。

### 2. 工程实现规范

- **BOM-Free UTF-8 批处理生成**：通过 .NET `[System.Text.UTF8Encoding]($false)` 原生输出批处理脚本，避免 Windows `cmd.exe` 在解析带 BOM 文件时语法错误；
- **动态网卡枚举匹配**：使用 `PhysicalAdapter = True` 与 `NetConnectionStatus = 2` 结合驱动描述动态定位真实网卡，避免硬编码网卡名称失效；
- **设备形态加权判断**：根据主板底盘类型代码（ChassisTypes）与电源管理子系统识别机型形态，自动过滤 UPS 备用电源。

---

## 目录结构 (Directory Tree)

```text
pc-hardware-master/
├── SKILL.md            # Agent 规范核心定义与交互工作流
├── README.md           # 项目开源说明文档
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

## 开源许可证 (License)

本项目遵循 [MIT License](LICENSE) 协议开源。
