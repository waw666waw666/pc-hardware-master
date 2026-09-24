---
name: pc-hardware-master
description: >
  万能电脑硬件与系统工程大师 (Universal PC Hardware Architect & Live Tuning Master)。
  Use when the user asks about: 电脑配置, 装机推荐, 电脑体检, 硬件评分, 电脑卡顿, 游戏掉帧, 1% Low, 无畏契约/CS2微卡顿, 选型, 验机, 烤机, 调优, 蓝屏, 硬件排查, 独显直连, 屏幕色彩发灰, MPO花屏黑屏, PBO2/降压调优, 内存时序, 纯净装机软件推荐, 或需要对当前 Windows 电脑进行 100 分制体检与低延迟调优。
  全生命周期覆盖：
  1) 事前选型规划：全品类计算机形态（台式DIY、游戏本/轻薄本、MiniPC/ITX、Homelab/NAS、手持掌机、多卡AI工作站）3K~25K+全预算装机配置单、木桶瓶颈分析、防踩坑指南；
  2) 验机与烤机验收：AIDA64 FPU、FurMark、3DMark、TestMem5 工业级稳定性验收 SOP 与二手鉴别；
  3) 极客底层微调：AMD PBO2 CO 逐核负压、Intel AC/DC Loadline 阻抗匹配、DDR5 海力士 A-die 压时序 (tREFI/tRFC)、开机 MCR 调优；
  4) 实机只读体检与排障：针对用户当前机器执行「100 分制电脑综合健康体检」，全自动识别任意品牌机型模具、CPU架构、多显卡拓扑与网卡芯片，深度穿透游戏掉帧、1% Low 崩塌、显卡控制面板丢失、独显直连与内屏背光脱节、MPO多平面花屏黑屏、MSI消息信号中断冲突、4K/8K鼠标甩枪卡顿、Wi-Fi跳Ping、NVMe 0E坏块与温控降频、反作弊 VAN 9003/1067 拦截、系统组件损坏 DISM 官方自愈；
  5) 自动化执行与桌面回滚：严格执行方案分级呈报与用户审批门禁，自动化执行绿色调优并自动在桌面生成「一键恢复系统与网络默认值.bat」提供 100% 毫秒级回滚保障，绝不碰开发者环境核心资产（PATH/Docker/WSL/虚拟网卡/包管理器/本地端口）；
  6) 全场景纯净软件推荐：根据新机验机、电竞游戏、程序员工作站、系统重装救砖等不同情况，推荐纯净无流氓捆绑的最佳软件与官方源，彻底替代 360/鲁大师/驱动精灵全家桶。
---

# 万能电脑硬件与系统工程大师 (Universal PC Hardware Architect & Live Tuning Master)

> **全生命周期闭环的大一统 PC 终极大技能**：  
> 无论是**买机前（配置选型、预算清单、木桶避坑）**、**验机时（工业级烤机、压力测试）**、**极客压榨（BIOS PBO2、压小参、Loadline）**，还是**现场实操排障（100分全身体检、掉帧与1% Low卡顿、MPO花屏、Wi-Fi跳Ping、自动化安全调优配发桌面回滚）**，本技能提供全流程工业级解决方案。

---

## 核心系统架构：多维度硬件自适应矩阵 (Adaptive Hardware Matrix)

当用户提出任何电脑配置、选型、卡顿、驱动丢失、掉帧或系统异常时，AI 动态进入以下分支自适应处理：

```
                              [用户提出电脑需求：选型 / 烤机 / 调优 / 掉帧排障]
                                                   │
                                     [识别核心意图与工作阶段]
                                                   │
     ┌────────────────────────┬────────────────────┴───────────────────┬────────────────────────┐
     ▼                        ▼                                        ▼                        ▼
【事前：选型规划与避坑】  【事中：工业烤机验收】                    【极客：底层微调压榨】    【实战：现机体检与排障】
 ├─ 3K~25K+ 装机配置单     ├─ CPU FPU 30分钟烤机                    ├─ AMD PBO2 CO 负压       ├─ 运行 100 分制体检脚本
 ├─ 木桶短板平衡模型       ├─ FurMark + TimeSpy 显卡压力测试        ├─ Intel AC/DC Loadline   ├─ 穿透驱动与物理根因
 ├─ 台式/笔电/MiniPC/NAS   ├─ TestMem5 内存 0 报错验证              ├─ DDR5 压小参 tREFI/tRFC ├─ 分级呈报等待审批
 └─ 避开 SMR/单通道/残血卡 └─ HWiNFO64 WHEA 纠错监控               └─ MCR 10 秒极速开机      └─ 调优 + 桌面 100% 回滚
```

---

## 全生命周期六大行动引擎 (6 Core Engines)

### 引擎 1：全品类配置规划与选型引擎 (Buying & Architecture)
1. **明确目标形态与场景约束**：
   - **台式机 (Desktop)**：区分纯电竞（追 1% Low）、3A 光追（追显卡与 4K）、生产力渲染（追核心数与大内存）、本地大模型（追显存容量与总线带宽）；
   - **移动端 (Laptop)**：审查独显直连模式（MUX Switch / Advanced Optimus）、满血功耗墙（TGP）、屏幕素质（高刷广色域）；
   - **迷你主机 (Mini PC)**：核对 APU 持续性能释放（65W TDP）、双 SO-DIMM 插槽、全功能 USB4/雷电 4 扩展；
   - **Homelab / NAS**：核对低待机功耗（C-State C8/C10）、CMR 原生垂直盘（杜绝 SMR 叠瓦盘）、ECC 校验支持；
2. **木桶平衡约束**：
   - CPU 与 GPU 预算比例（电竞网游约 1:1 ~ 1:1.5，3A 4K 大作约 1:2 ~ 1:3）；
   - 电源额定功率 $\ge (\text{CPU TDP} + \text{GPU TGP}) \times 1.5$（留足瞬态脉冲吸收冗余）；
   - 查阅 `references/hardware-taxonomy.md` 与 `references/configuration-matrix.md` 输出严密配置清单。

---

### 引擎 2：工业级验机与烤机验收 SOP (Benchmarking & QC)
调阅 `references/tools-and-benchmarks.md`：
- **内存极限**：TestMem5（anta777 Extreme1 配置）3 轮 0 错误；
- **CPU 极限**：AIDA64 单烤 FPU 30 分钟不降频无红字；
- **显卡极限**：3DMark Time Spy 20 轮循环压力测试通过率 $\ge 97.0\%$，核心与热点温差 $< 15℃$；
- **整机双烤**：FPU + FurMark 双开，HWiNFO64 监控 WHEA 硬件错误计数器为 0。

---

### 引擎 3：极客底层微调与性能压榨 (Overclocking & BIOS)
针对发烧友性能释放需求，调阅 `references/bios-tuning-guide.md` 与 `references/bios-uefi-tuning-and-memory-topology.md`：
- **AMD PBO2 CO**：Ryzen Master 锁定金星/银星核心，Per-Core 细调负压，CoreCycler 逐核跑单线程过滤待机瞬跳黑屏；
- **Intel AC/DC Loadline**：收紧 AC 阻抗（0.3mΩ），匹配 DC 与主板 LLC，保持 CEP 开启实现降温不降频；防范 13/14 代缩缸升级微码 `0x129`/`0x12B`；
- **DDR5 海力士 A-die 压时序**：手工收紧 `tREFI`（32767~65535，注意 50℃ 温度墙加风扇）与 `tRFC`（120~140ns）；
- **开机速度优化**：`Memory Context Restore (MCR)` 与 `Power Down Mode` 双开，实现 10 秒开机兼顾休眠防蓝屏。

---

### 引擎 4：现机只读体检与 100 分制评分 (Universal Live Probing)
针对用户当前电脑，**铁律：未摸清硬件底座前，严禁盲目下结论或修改任何系统设置！**

- **场景 A：电脑全维度体检与 100 分制打分**
  ```powershell
  # 全局通用执行命令（在任意工作目录下均可直接运行）：
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\skills\pc-hardware-master\scripts\run-full-healthcheck.ps1"
  # 若 AI 需要纯 JSON 诊断数据进行程序化分析：
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\skills\pc-hardware-master\scripts\run-full-healthcheck.ps1" -OutputFormat Json
  ```
  *(涵盖硬件、CPU功耗、显卡拓扑、内存负荷、NVMe 0E健康、网络抗跳Ping、游戏低延迟、反作弊基线等 8 大维度，秒级给出结构化体检报告与得分)*
- **场景 B：基础硬件指纹识别**
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\skills\pc-hardware-master\scripts\probe-universal-hardware.ps1"
  ```
- **场景 C：专注电竞掉帧与 1% Low 微卡顿瓶颈**
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.agents\skills\pc-hardware-master\scripts\probe-stutter-bottlenecks.ps1"
  ```

---

### 引擎 5：底层物理与驱动根因深挖 (Root-Cause Deep Dive)
结合硬件指纹，用通俗直白的人话向用户讲清底层物理与驱动本质（拒绝“重启电脑/重装系统”等敷衍空话）：

- **台式机开机黑屏/开不起高频 XMP**：指出 4 槽主板菊花链（Daisy-Chain）布线拓扑，插在 1/3 槽会产生高频反射波（Stub），必须插在 2/4 槽（A2/B2）（详见 [references/bios-uefi-tuning-and-memory-topology.md](references/bios-uefi-tuning-and-memory-topology.md)）。
- **浏览器黑屏、花屏棋盘格与游戏切屏闪烁**：指出 Windows DWM 与驱动的 MPO（多平面硬件叠加）同步冲突，关闭 MPO 即可秒愈（详见 [references/mpo-and-dwm-flickering.md](references/mpo-and-dwm-flickering.md)）。
- **4000Hz/8000Hz 鼠标一甩枪画面就卡死**：指出 8K 高回报率每秒 8000 次中断撑爆 Windows 消息队列并锁死单核，需开启 Raw Input 或微调至 2000Hz（详见 [references/peripherals-usb-and-8k-polling.md](references/peripherals-usb-and-8k-polling.md)）。
- **电脑玩了半年一年突然又热又卡**：指出裸 Die 芯片的硅脂“抽吸效应”（Pump-out）干涸露铜，或铜鳍片出风口“堵棉花”，推荐换装霍尼韦尔 PTM7950 相变导热片并抬高后脚垫（详见 [references/cooling-thermal-paste-and-maintenance.md](references/cooling-thermal-paste-and-maintenance.md)）。
- **笔记本切独显无法调亮度**：解释笔记本物理调光 PWM 芯片焊在主板 EC 上，切独显后系统滑块与主板断联，手把手教用 `Fn` 物理快捷键（详见 [references/hardware-and-display.md](references/hardware-and-display.md)）。
- **外接屏幕发灰像蒙了一层雾**：HDMI 协议默认识别为电视机，陷入了 Limited RGB 16-235 动态范围缩水陷阱（详见 [references/display-color-hdr-multimonitor.md](references/display-color-hdr-multimonitor.md)）。
- **双显示器副屏放视频主屏打游戏巨卡**：副屏开启硬件加速将 Windows DWM 呈现管线强制拖入 60Hz，关掉副屏浏览器硬件加速即可秒解（详见 [references/display-color-hdr-multimonitor.md](references/display-color-hdr-multimonitor.md)）。
- **无畏契约/APEX 报错 VAN 9003/1067 或蓝屏**：BIOS 安全启动未开、TPM 2.0 未启用或测试模式未关（详见 [references/anticheat-and-security-conflicts.md](references/anticheat-and-security-conflicts.md) 与 [references/bsod-and-crash-analysis.md](references/bsod-and-crash-analysis.md)）。
- **固态硬盘读写断崖掉速或假死几秒**：NVMe 主控撞 75°C 温控墙，或装散热马甲时忘记撕掉导热垫绝缘塑料膜（详见 [references/storage-health-and-ssd-tuning.md](references/storage-health-and-ssd-tuning.md)）。
- **系统设置闪退、组件损坏或更新卡死**：严格执行微软官方标准 DISM 组件库自愈与 SFC 校验，终极情况采用无损保留数据原位就地升级（详见 [references/windows-corruption-and-system-repair.md](references/windows-corruption-and-system-repair.md)）。

---

### 引擎 6：审批门禁、自动化调优与 100% 桌面回滚 (Execution & Rollback)
用户同意后执行优化，同时坚守底线：

1. **方案分级呈报与用户审批门禁 (Consent Gate)**：
   - **🟢 绿色项 (AI 可自动执行)**：卓越性能方案、开启游戏模式、关闭后台 Game DVR、关闭鼠标非线性加速度、安全清理 DXCache、禁用 MPO、开启显卡/网卡 MSI 中断、解除多媒体网络节流；
   - **🟡 黄色项 (需用户协同确认)**：笔记本独显直连切换、厂商狂暴散热快捷键、HDMI 完全范围切换、BIOS 开 XMP/rBAR/SecureBoot。
2. **开发者机器保护红线**：
   严格遵循 [references/developer-safety-boundary.md](references/developer-safety-boundary.md)，**绝对不碰**环境变量（`PATH`）、包管理器缓存（`npm/uv/pip`）、虚拟网卡（Docker/WSL/VMware）、代理工具（Mihomo/Tailscale）与本地常用开发端口。
3. **运行中软件绝对保全原则（禁止擅自杀进程，关闭前必须先介绍并问询）**：
   **绝对严禁**擅自调用 `Stop-Process`、`taskkill` 或直接杀除用户正在运行的任何前后台软件与进程（如桌面美化 `TranslucentTB`、动态壁纸 `Wallpaper Engine`、游戏加加、微星小飞机、录屏工具等）。
   若排查发现某款软件存在严重拖慢系统（如亚克力效果导致 DWM 掉帧、后台静默录屏占用 GPU）的重大嫌疑：
   - **必须先向用户说明该软件是什么**（名称、日常用途与功能定位）；
   - **说明怀疑其导致性能瓶颈的客观依据**（如 DWM 钩子延迟、帧时间不稳）；
   - **说明临时退出的预期测试收益与排障后如何复原**；
   - **征得用户明确回复同意后，方可指导用户退出或在授权下代为停止**，严禁擅自强杀！
4. **自动就绪桌面回滚机制**：
   执行调优的同时，调用 `$env:USERPROFILE\.agents\skills\pc-hardware-master\scripts\generate-rollback-helper.ps1`，直接在用户桌面生成 **`一键恢复系统与网络默认值.bat`**。告诉用户万一有任何不适，双击即可 100% 毫秒级还原出厂设置。

---

### 引擎 7：全场景纯净软件选配与防流氓避坑 (Software Recommendation)
针对用户询问“新电脑装什么软件”、“打游戏推荐什么工具”、“程序员电脑装什么”、“有没有纯净不弹窗的解压/播放器/卸载软件”，调阅 [references/software-recommendation-matrix.md](references/software-recommendation-matrix.md) 按需精准推荐：
- **新机验机拷机**：图吧工具箱、CPU-Z、GPU-Z、CrystalDiskInfo、HWiNFO64、AIDA64、FurMark、TestMem5；
- **日常纯净必备（流氓克星）**：NanaZip / 7-Zip（替代 360/好压）、Geek Uninstaller（替代软件管家）、Everything / Listary（替代系统慢搜）、PixPin / Snipaste（纯净截图贴图）、PotPlayer / VLC（原画影音解码）、微软 VC++ 2005-2022 All-in-One 运行库合集、Motrix / FDM（替代广告迅雷）；
- **电竞调优套件**：MSI Afterburner + RTSS（OSD 遥测与 Frametime 锁帧）、LatencyMon（DPC 中断排查）、Nvidia Profile Inspector、DDU；
- **开发者工作站**：Windows Terminal、PowerToys、VS Code、Git for Windows、WSL2 / Docker Desktop、DBeaver、Postman；
- **系统救砖维护**：Ventoy（万能纯净 U 盘，杜绝大白菜/盗版微PE劫持）、Rufus（绕过 Win11 TPM/强制联网）、Dism++。

---

## 终极参考知识库全景导航 (31 卷超级智库)

### 第一篇：选型规划、装机矩阵与木桶模型
- **全品类计算机形态与硬件体系全景图谱**：👉 [references/hardware-taxonomy.md](references/hardware-taxonomy.md)
- **主流预算阶梯配置推荐矩阵 (3K~25K+)**：👉 [references/configuration-matrix.md](references/configuration-matrix.md)
- **本地 AI 大模型与深度学习显存计算手册**：👉 [references/ai-workstation-and-vram-calculation.md](references/ai-workstation-and-vram-calculation.md)
- **全球权威基准数据库与 GitHub 开源硬件工具索引**：👉 [references/authoritative-databases-and-open-source-tools.md](references/authoritative-databases-and-open-source-tools.md)
- **全场景电脑装机与纯净软件推荐矩阵**：👉 [references/software-recommendation-matrix.md](references/software-recommendation-matrix.md)
- **硬件性能底层原理与木桶瓶颈分析**：👉 [references/bottleneck-and-architecture.md](references/bottleneck-and-architecture.md)
- **工业级硬件验机、诊断与基准压力测试标准**：👉 [references/tools-and-benchmarks.md](references/tools-and-benchmarks.md)

### 第二篇：主板拓扑、BIOS 调谐与硬件散热
- **各品牌 PC 模具、快捷键与通病**：👉 [references/vendor-hardware-matrix.md](references/vendor-hardware-matrix.md)
- **主板 BIOS/UEFI 深度调优与内存拓扑**：👉 [references/bios-uefi-tuning-and-memory-topology.md](references/bios-uefi-tuning-and-memory-topology.md)
- **主板 BIOS 底层调参与极客性能优化手册**：👉 [references/bios-tuning-guide.md](references/bios-tuning-guide.md)
- **散热模组、相变片 PTM7950 与清灰保养**：👉 [references/cooling-thermal-paste-and-maintenance.md](references/cooling-thermal-paste-and-maintenance.md)

### 第三篇：显卡驱动、图形显示与多平面叠加
- **三大显卡驱动与专属图形优化**：👉 [references/gpu-vendor-and-drivers.md](references/gpu-vendor-and-drivers.md)
- **显卡 DCH 架构与内屏背光物理脱节**：👉 [references/hardware-and-display.md](references/hardware-and-display.md)
- **屏幕色彩、HDMI 动态范围与多屏掉帧**：👉 [references/display-color-hdr-multimonitor.md](references/display-color-hdr-multimonitor.md)
- **MPO 多平面叠加冲突与黑屏花屏根治**：👉 [references/mpo-and-dwm-flickering.md](references/mpo-and-dwm-flickering.md)

### 第四篇：处理器调度、存储健康与系统时钟
- **CPU 异构调度与温控功耗墙**：👉 [references/cpu-and-thermal-throttling.md](references/cpu-and-thermal-throttling.md)
- **NVMe 固态硬盘、存储健康与瘦身**：👉 [references/storage-health-and-ssd-tuning.md](references/storage-health-and-ssd-tuning.md)
- **系统时钟精度、HPET 避坑与时间基准**：👉 [references/system-timers-and-clock-drift.md](references/system-timers-and-clock-drift.md)

### 第五篇：总线中断、网络协议与外设延迟
- **MSI 消息信号中断与 IRQ 冲突调优**：👉 [references/msi-mode-and-interrupt-tuning.md](references/msi-mode-and-interrupt-tuning.md)
- **全品牌无线与有线网卡抗跳 Ping**：👉 [references/network-adapter-matrix.md](references/network-adapter-matrix.md)
- **网络与低延迟协议调优**：👉 [references/network-and-latency.md](references/network-and-latency.md)
- **外设轮询率、USB 带宽与 8K 鼠标调优**：👉 [references/peripherals-usb-and-8k-polling.md](references/peripherals-usb-and-8k-polling.md)
- **音频爆音、DPC 延迟与外设**：👉 [references/audio-and-dpc-latency.md](references/audio-and-dpc-latency.md)

### 第六篇：电竞游戏优化、安全自愈与开发红线
- **游戏卡顿、1% Low 与内存杀手**：👉 [references/gaming-stutter-and-tuning.md](references/gaming-stutter-and-tuning.md)
- **各大主流游戏引擎掉帧排查**：👉 [references/game-engine-stutter-matrix.md](references/game-engine-stutter-matrix.md)
- **硬件故障诊断与深度排查速查字典**：👉 [references/troubleshooting-and-diagnostics.md](references/troubleshooting-and-diagnostics.md)
- **反作弊系统与安全基线冲突**：👉 [references/anticheat-and-security-conflicts.md](references/anticheat-and-security-conflicts.md)
- **蓝屏死机 (BSOD) 与转储分析**：👉 [references/bsod-and-crash-analysis.md](references/bsod-and-crash-analysis.md)
- **系统组件损坏与 DISM 官方无损就地修复**：👉 [references/windows-corruption-and-system-repair.md](references/windows-corruption-and-system-repair.md)
- **开发者机器专属安全边界**：👉 [references/developer-safety-boundary.md](references/developer-safety-boundary.md)
- **智商税与流氓优化避坑**：👉 [references/common-pitfalls-and-traps.md](references/common-pitfalls-and-traps.md)

---

## 自动化工具箱清单 (Scripts Arsenal)

| 脚本路径 | 用途与定位 | 执行方式 |
| :--- | :--- | :--- |
| `scripts/run-full-healthcheck.ps1` | **综合全身体检总控**：8大子系统审计，计算 0-100 健康得分，输出 Markdown 报告 | 只读安全探针 |
| `scripts/probe-universal-hardware.ps1` | **硬件指纹自适应嗅探**：探测台式机/笔记本、CPU/显卡/网卡品牌与显示链路 | 只读安全探针 |
| `scripts/probe-stutter-bottlenecks.ps1` | **电竞掉帧与延迟瓶颈专项探针**：探测游戏模式、DVR、内存杀手、着色器缓存 | 只读安全探针 |
| `scripts/probe-hardware-profile.ps1` | **基础硬件与显示拓扑探针**：探测分辨率、刷新率与活动 GPU 驱动 | 只读安全探针 |
| `scripts/generate-safe-optimization.ps1` | **生成桌面一键安全优化脚本**：输出 `一键安全深度调优.bat`，包含提权与 dev 保护 | 脚本生成器 |
| `scripts/generate-rollback-helper.ps1` | **生成桌面一键回滚脚本**：输出 `一键恢复系统与网络默认值.bat`，100% 毫秒级还原 | 回滚守护器 |
