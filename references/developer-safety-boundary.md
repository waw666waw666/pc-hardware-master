# 开发者机器专属安全边界与风险分级规范 (Developer Safety Boundary & Risk Levels)

本手册专为 AI Agent 在**开发者主力机（具备复杂编程、容器化、虚拟化与代理环境）**上执行系统排查与性能调优时设立的**不可逾越的安全红线与风控准则**。

---

## 一、开发者机器的六大不可动摇红线（The Non-Negotiables）

在开发者的电脑上，系统不仅用于娱乐，更承载着核心生产力。任何盲目的优化如果导致编译失败、端口冲突或虚拟网卡中断，都是灾难性的。

### 1. 绝不篡改系统环境变量
- 严禁清空、重排或篡改用户的 `PATH`、`JAVA_HOME`、`PYTHONPATH`、`GOROOT`、`CARGO_HOME`、`CUDA_PATH` 等开发环境变量；
- 注册表修改仅限指定的系统策略分支（如 GameBar、GameConfigStore、Multimedia），绝不执行无差别环境变量重置。

### 2. 绝不误杀包管理器与开发缓存
- 严禁擅自清理或删除：
  - `node_modules`、`.npm`、`pnpm-store`；
  - `uv`、`pip` 缓存、`.conda`、虚拟环境目录；
  - `.git` 仓库索引、`.ssh` 密钥、`.gnupg`；
  - 本地大模型权重（HuggingFace、Ollama、vLLM、GGUF 目录）。

### 3. 绝不破坏容器与虚拟网卡
- 很多小白优化脚本喜欢“一键清理无用网卡”，这会直接瘫痪开发者的网络：
  - **Docker Desktop** (`vEthernet (WSL)`)；
  - **VMware Workstation** (`VMnet1`, `VMnet8`)；
  - **Tailscale / 异地组网**；
  - **代理工具**（Mihomo / Clash / V2Ray 的 TUN 虚拟网卡）。
- 任何网络调优命令必须明确限定物理网卡名称（如 `-Name 'WLAN'` 或 `-Name '以太网'`），严禁全局通配符遍历修改！

### 4. 绝不占用或封锁常用开发端口与本地回路
- 本地端口 `3000`、`5173` (Vite)、`8080`、`8000`、`5000`、`14007` (OpenDesign)、`11434` (Ollama) 等是开发服务的生命线；
- 严禁修改 Windows 本地回路（`127.0.0.1` / `localhost`）的代理规则与防火墙入站白名单。

### 5. 绝不永久硬删除任何用户文件
- 必须遵循 **零伤害（Zero-Harm）原则**；
- 临时文件清理若无特定 API，必须移动到 Windows 回收站（`SendToRecycleBin`），确保 100% 可撤回。

### 6. 所有优化操作必须支持 1-Click 还原
- 每当准备修改注册表、系统服务或电源方案前，必须明确知晓其出厂默认值，并在交付优化时**同步向用户提供对应的回滚命令或还原批处理脚本**。

---

## 二、优化项目四级风险分级制度 (4-Tier Risk Matrix)

| 风险等级 | 定义与范围 | 执行授权策略 | 典型项目 |
| :--- | :--- | :--- | :--- |
| **🟢 LOW<br>(无损纯正向)** | 零负面影响、官方原生支持、不改变任何业务逻辑与日常软件功能 | **用户提出排查并确认后，AI 可直接自动批量执行** | - 解锁官方「卓越性能」电源计划<br>- 开启 Windows「游戏模式」<br>- 关闭后台 Xbox Game DVR 静默录屏<br>- 关闭 Windows 鼠标系统级非线性加速<br>- 清理已失效的历史 NVIDIA DXCache 着色器 |
| **🟡 MEDIUM<br>(单项可逆调优)** | 针对特定硬件属性微调、针对特定干扰进程的治理，改动仅局限在局部硬件通道 | **呈报修改细节，获得明确同意后执行；且必须提供回退脚本** | - 终止并移除 `Mem Reduct` 内存清理自启<br>- 调整 Intel Wi-Fi 漫游主动性为最低<br>- 调整 Intel Wi-Fi MIMO 节电为无 SMPS<br>- 禁用 USB 选择性省电挂起<br>- 解除 Windows 多媒体网络限流 (`NetworkThrottlingIndex`) |
| **🟠 HIGH<br>(深度环境改动)** | 涉及第三方软件配置更改、核心系统服务禁用、虚拟内存（分页文件）调整 | **必须先详细解释利弊，禁止自动执行，优先引导用户手动确认** | - 修改《无畏契约》本地 `GameUserSettings.ini` 画质配置<br>- 禁用 Windows Search 索引服务 (`WSearch`)<br>- 禁用 SysMain 服务 (`SysMain`)<br>- 调整物理虚拟内存 (Pagefile) 大小 |
| **🔴 CRITICAL<br>(高危禁区)** | 涉及硬件底层固件、物理电压调节、极易导致黑屏或系统损坏的操作 | **严禁 AI 擅自用脚本自动化执行，只能通过保姆级文字指导用户在物理层面操作** | - 切换显卡硬件 MUX 芯片线路（黑屏 1~2 秒须用户交互确认）<br>- 笔记本进入 BIOS 修改 UEFI 固件寄存器<br>- 显卡/CPU 核心电压曲线微调（降压超频）<br>- 动用系统内部重置命令（`/ResetBase`、清空 Installer 目录） |
