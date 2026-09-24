# 显卡架构、显示模式与内屏硬件排障手册 (Hardware & Display Diagnostic Guide)

本手册专为 AI Agent 排查 Windows 消费级 PC（尤其是游戏本与双显卡主机）的显卡驱动、显示模式、刷新率与内屏控制问题提供深度底层知识与实战对策。

---

## 一、现代显卡 DCH 驱动架构与控制面板缺失根因

### 1. 什么是 DCH 驱动？
自 Windows 10 1809 之后，微软强制主流硬件厂商（NVIDIA、AMD、Intel）采用 **DCH（Declarative Componentized Hardware Support App）** 标准驱动：
- **声明性 (Declarative)**：驱动只包含最底层的硬件通信与渲染指令。
- **组件化 (Componentized)**：驱动拆分为独立的扩展包（Extension INF）。
- **硬件支持应用 (Hardware Support App, HSA)**：用户图形界面（如 NVIDIA Control Panel、Intel Graphics Command Center）**不再打包在驱动安装包内部**，而是作为独立 UWP/AppX 应用上架微软应用商店（Microsoft Store）。

### 2. 为什么“NVIDIA 控制面板”会凭空消失？
当用户反馈“我的英伟达控制面板没了/右键不见了”，95% 以上由以下三类情况引起：
1. **Windows 自动更新驱动劫持**：Windows Update 在后台推送了一个纯粹的精简 DCH 驱动，覆盖了原有驱动，但没有自动通过商店拉取配套的 UWP 应用程序。
2. **微软商店通信受阻**：驱动安装完成后，系统本应静默调用微软商店 API 下载 `NVIDIACorp.NVIDIAControlPanel`，若当前网络受限、关闭了 Windows Update 服务、或开了某些精简版系统，该组件安装静默失败。
3. **新旧生态交替 (NVIDIA App)**：用户更新了最新的 NVIDIA App，英伟达在某些版本中试图逐步用新版 App 替代旧版控制面板，导致旧版快捷方式与右键被清理。

### 3. 排查与修复标准工作流
- **只读探测**：
  ```powershell
  # 检查传统控制面板是否存在
  Test-Path "C:\Program Files\NVIDIA Corporation\Control Panel Client\nvcplui.exe"
  # 检查微软商店 UWP 版本是否安装
  Get-AppxPackage *NVIDIACorp.NVIDIAControlPanel*
  ```
- **自动化无损修复**：
  优先调用本机的 `winget` 从微软官方商店静默拉取官方包（版本 `8.1.969.0+`）：
  ```powershell
  winget install --id 9NF8H0H7WMLT --source msstore --accept-package-agreements --accept-source-agreements
  ```
- **备用人工修复（提供给用户的一键直达链接）**：
  ```text
  Win + R 输入：ms-windows-store://pdp/?productId=9NF8H0H7WMLT
  ```

---

## 二、双显卡架构与独显直连（Optimus vs MUX Switch）

### 1. 混合输出模式 (MSHybrid / Optimus)
- **物理拓扑**：笔记本内屏排线在物理电路上直接连接在 **CPU 核显 (Intel UHD/Iris Xe 或 AMD Radeon 600M/700M)** 上。
- **工作机制**：当启动 3D 游戏时，独立显卡（如 RTX 4050）负责计算和渲染每一帧画面，然后通过 PCIe 总线将整个帧缓冲区（Frame Buffer）拷贝给核显，最后由核显输出给屏幕刷新。
- **致命缺陷**：
  - **严重跳帧与 1% Low 崩塌**：高刷新率竞技游戏（如《无畏契约》、《CS2》）动辄 200~300 FPS。每秒在 PCIe 总线和内存之间搬运数以亿计的像素数据，带来极大的内存带宽挤占与帧生成延迟抖动（Frame Time Jitter）。
  - **单核/核显瓶颈**：核显如果处于省电状态或受限于核显驱动，会导致帧率剧烈波动。

### 2. 独显直连 (Discrete GPU Only / MUX Switch)
- **物理拓扑**：主板上焊有硬件多路复用芯片（MUX 芯片）。切换后，屏幕排线在物理电路层面直接切接到独立显卡上，彻底绕过核显。
- **分类**：
  - **Advanced Optimus（动态显示切换 DDS）**：通过英伟达 NVAPI 与显示多路复用驱动，在 Windows 系统内无感切换。切换时**屏幕会瞬间黑屏 1~2 秒**（硬件切线正常现象）。
  - **硬件 BIOS 直连（硬直连）**：在电脑开机自检（POST）阶段，通过 BIOS 设置将 MUX 芯片永久锁在独显端，进入系统后核显甚至不会被操作系统识别。性能最稳定，彻底消除驱动热切换冲突。

### 3. 排查命令
```powershell
# 查看内屏当前挂载在哪张显卡上（看哪张显卡拥有当前分辨率和刷新率）
Get-CimInstance Win32_VideoController | Select-Object Name, CurrentHorizontalResolution, CurrentVerticalResolution, CurrentRefreshRate
```
- 若 `Intel(R) UHD Graphics` 显示 1920x1080@165Hz，而 NVIDIA 显卡的分辨率为空，则说明当前处于**核显混合模式**，未开独显直连！

---

## 三、戴尔/外星人/华硕游戏本切独显直连后“无法调节亮度”的物理底层根因

### 1. 为什么滑条拖动了屏幕亮度纹丝不动？
这是几乎所有配备 Advanced Optimus 游戏本（尤其是戴尔 G15/G16、外星人、华硕天选/ROG）的**经典硬件架构机制**：
- **物理调光电路归属**：内屏的液晶面板物理背光（PWM 脉宽调制信号芯片），硬件电路上是焊接在主板的 **嵌入式控制器 (EC, Embedded Controller)** 或 Intel 芯片组总线上的。
- **控制权割裂**：
  - 在核显模式下，Windows 亮度滑块通过调用 Intel 核显驱动的 ACPI 接口，间接控制 EC 芯片的 PWM 占空比，因此调节正常。
  - 当在英伟达控制面板热切换到“仅限 NVIDIA GPU”后，屏幕显示通道切给独显，但 Windows 11 的右下角控制中心试图通过 NVIDIA 独显驱动去发调光指令，而 NVIDIA 驱动并未适配该笔记本主板私有的 EC 调光协议，导致指令悬空。

### 2. 人性化保姆级对策（由快到慢）
1. **键盘物理硬件快捷键（100% 物理有效）**：
   - 按键盘上的 **`F6`（降低亮度）/ `F7`（增加亮度）**（戴尔笔记本）或 `Fn + F6/F7`。
   - 键盘上的物理亮度键是由主板 EC 芯片固件直接处理的，完全不经过显卡驱动，独显直连下绝对好使。
2. **重启电脑（重新握手）**：
   - 戴尔 G15 在热切换后经常出现背光句柄断联。只要重启一次，Windows 会在冷启动自检时以独显为主设备重新加载背光驱动，右下角滑块通常会恢复。
3. **NVIDIA 控制面板软件级色彩调光**：
   - NVIDIA 控制面板 -> 显示 -> 调整桌面颜色设置 -> 拖动“亮度”与“对比度”滑条（通过 GPU 信号输出 LUT 调节，屏幕虽然背光不变，但画面呈现直观明暗调节）。
4. **BIOS 硬切独显**：
   - 开机狂按 F2 进 BIOS -> Display -> 开启 Direct Graphics Controller，一劳永逸。

---

## 四、Multiplane Overlay (MPO) 桌面多平面叠加引发的卡顿与撕裂

### 1. MPO 机制缺陷
Windows 10/11 的 DWM（桌面窗口管理器）引入了 MPO，允许游戏和视频窗口在无需经过 DWM 统一合成的情况下直接送显。然而在很多双显卡或特定 NVIDIA 驱动版本下，当桌面同时运行全屏游戏与带有硬件加速的软件（如 Discord、Chrome、微信、QQ）时，MPO 调度冲突会导致：
- 画面偶尔瞬间黑屏闪烁；
- 切屏时游戏严重卡死或瞬时掉帧。

### 2. 诊断与禁用对策
```powershell
# 检查是否关闭了 MPO
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayTestMode" -ErrorAction SilentlyContinue

# 官方安全禁用 MPO 方案（NVIDIA 官方支持方案）
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d 5 /f
```
*(恢复只需将该键值删除并重启电脑即可)*
