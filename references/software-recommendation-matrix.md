# 全场景电脑装机与纯净软件推荐矩阵 (Situation-Based Software Recommendation Matrix)

本指南针对新电脑到手、系统重装或日常优化场景，根据用户不同使用角色（普通办公、电竞游戏、程序员开发、硬件验机与极客维护），提供**100% 纯净、无广告弹窗、无后台捆绑流氓行为的工业级软件推荐方案**，并提供流氓软件官方克星替代品清单。

---

## 一、 快速定位：按使用场景选配软件清单

```
                                [电脑软件安装需求分类]
                                          │
    ┌──────────────┬──────────────────────┼──────────────────────┬──────────────┐
    ▼              ▼                      ▼                      ▼              ▼
【新机验机拷机】  【日常纯净装机必备】    【电竞游戏调优套件】   【开发者工作站】 【系统维护救砖】
 ├─ CPU-Z/GPU-Z   ├─ NanaZip/7-Zip       ├─ MSI Afterburner+RTSS ├─ VS Code     ├─ Ventoy (U盘)
 ├─ CrystalDisk   ├─ Geek Uninstaller    ├─ LatencyMon          ├─ Windows Term ├─ Rufus
 ├─ HWiNFO64      ├─ Everything/Listary  ├─ Nvidia Profile Insp ├─ Git / Docker ├─ Dism++
 └─ 图吧工具箱   ├─ PixPin / Snipaste   └─ DDU 显卡驱动清理    └─ DBeaver/API  └─ Macrium/备份
                  ├─ PotPlayer / VLC
                  ├─ 微软官方VC++合集
                  └─ Motrix / FDM
```

---

## 二、 场景一：新机到手验机、二手鉴别与稳定性烤机软件

新电脑拆封或二手配件到手，**第一准则：切勿直接联网安装第三方驱动管理类软件**，优先使用免安装纯净单文件工具链进行硬件核验：

| 软件名称 | 定位与核心用途 | 获取方式 / 官网 | 特性与防翻车注意 |
| :--- | :--- | :--- | :--- |
| **图吧工具箱 (Tubatools)** | 开源离线硬件综合维护箱 | [GitHub: luolangaga/tubatools](https://github.com/luolangaga/tubatools) | 纯净便携单目录，集成了数百款检测软件与 CPU/显卡性能天梯图，断网也能验机。 |
| **CPU-Z** | 处理器架构、时序与主板版本 | [CPUID 官网](https://www.cpuid.com/softwares/cpu-z.html) | 查看单核/多核跑分、内存是否激活双通道与 Gear 1/2 分频。 |
| **GPU-Z** | 显卡规格、PCIe 协议协商 | [TechPowerUp 官网](https://www.techpowerup.com/gpuz/) | 点击“?”开启渲染负载，查看 PCIe 是否协商在满血 4.0/5.0 x16，杜绝金手指下垂降级。 |
| **CrystalDiskInfo** | 硬盘 S.M.A.R.T. 健康与通电 | [Crystal Dew World](https://crystalmark.info/) | 新机重点查“通电时间 < 10 小时”、“通电次数 < 50 次”，排查 05/0E 坏块重映射。 |
| **HWiNFO64** | 全机底层物理传感器深度遥测 | [HWiNFO 官网](https://www.hwinfo.com/) | 监控 VRM 供电温度、GPU Hotspot（热点结温）、内存温度，底部重点监控 **WHEA 错误计数器**。 |
| **AIDA64** | CPU 浮点极限烤机 (Stress FPU) | [AIDA64 官网](https://www.aida64.com/) | 单烤 FPU 30 分钟不降频、无红字报警。 |
| **FurMark (甜甜圈)** | 显卡核心与供电满载压测 | [Geeks3D 官网](https://geeks3d.com/furmark/) | 4K 分辨率压测 20 分钟，核心温差 < 15℃，验证电源抗瞬态尖峰能力。 |
| **TestMem5 (TM5)** | 内存极客超频与数据位翻转压测 | 搭配 anta777 Extreme1 配置 | 跑 3 轮 0 错误，排除内存微小欠压与时序不稳定造成的蓝屏。 |

---

## 三、 场景二：日常纯净装机必备软件（流氓软件终结者）

杜绝安装任何包含广告弹窗、主页篡改、锁屏壁纸推送的全家桶软件，推荐以下开源、轻量且纯净的绝对标准：

### 1. 解压缩软件
*   **首选推荐：NanaZip**
    *   **优势**：开源现代版 7-Zip，原生完美适配 Windows 11 新版右键折叠菜单，无弹窗、支持全部主流格式（.7z, .zip, .rar, .tar, .iso），支持微软商店直接安装。
    *   **备选推荐**：**7-Zip**（经典纯净、占用内存不足 2MB）。
    *   ❌ **坚决摒弃**：360压缩、好压（2345全家桶）、快压（附带弹窗与挖矿插件）。

### 2. 软件彻底卸载工具
*   **首选推荐：Geek Uninstaller**
    *   **优势**：单文件免安装（仅约 6MB），卸载程序后深度扫描并强制清理注册表残留、`AppData` 冗余文件夹与右键残留菜单。
    *   **备选推荐**：**Bulk Crap Uninstaller (BCUninstaller)**（开源批量卸载神器，支持静默卸载顽固流氓软件）。
    *   ❌ **坚决摒弃**：腾讯软件管家、360软件管家（常驻后台、劫持默认程序）。

### 3. 本地毫秒级全盘搜索
*   **首选推荐：Everything (Voidtools)**
    *   **优势**：基于 NTFS 磁盘 USN 日志秒级建立百万文件索引，输入关键词 0.001 秒即出结果，内存占用仅数十兆。
    *   **协同推荐：Listary**
    *   **优势**：双击 `Ctrl` 任意界面唤出搜索框，快速定位文件并直接在文件选择框中快速跳转目录。
    *   ❌ **坚决摒弃**：Windows 默认卡顿假死的全局慢速搜索。

### 4. 极致截图与贴图工具
*   **首选推荐：PixPin**
    *   **优势**：国内独立开发者纯净力作，集截图、贴图、离线离屏 OCR 文字识别、长截图、取色器与动图录制于一身，体验超越传统工具。
    *   **备选推荐：Snipaste**
    *   **优势**：行业公认的贴图利器，支持将截图直接钉在桌面任意窗口最上层，像素级放大标尺。

### 5. 万能影音解码播放器
*   **首选推荐：PotPlayer (配合纯净解码)**
    *   **优势**：强大平滑的硬件加速与格式兼容性（支持配合 LAV Filters + madVR 渲染高规格 4K HDR 视频）。*安装时注意取消勾选捆绑软件。*
    *   **备选推荐：VLC Media Player**
    *   **优势**：完全自由开源、跨平台、终身无任何弹窗广告，内建全部音频/视频编解码器。
    *   ❌ **坚决摒弃**：暴风影音、迅雷影音、爱奇艺播放器（锁屏广告、常驻服务注入）。

### 6. 系统运行库与环境底层必备
*   **首选推荐：微软官方 Visual C++ 2005~2022 All-in-One 运行库合集**
    *   **用途**：解决几乎所有“缺少 MSVCR120.dll / VCRUNTIME140.dll / 应用程序无法正常启动 (0xc000007b)”问题。
    *   **获取**：从 GitHub 开源项目或官方纯净源下载批处理一键安装包。
*   **DirectX End-User Runtimes (June 2010)**：
    *   **用途**：补齐经典 DX9 / DX11 老游戏运行所需的 Direct3D 扩展库文件。

### 7. 纯净多线程下载工具
*   **首选推荐：Motrix**
    *   **优势**：开源桌面下载软件，内置 Aria2 引擎，支持 HTTP、FTP、BitTorrent、Magnet（磁力），界面清爽极简无广告。
    *   **备选推荐：Free Download Manager (FDM)**
    *   **优势**：经典老牌多线程加速器，支持断点续传与网页音视频抓取。
    *   ❌ **坚决摒弃**：普通版迅雷（满屏新闻短视频推销、强制后台限速与捆绑插件）。

---

## 四、 场景三：电竞游戏发烧友专属套件 (Low Latency Gaming)

| 软件工具 | 核心用途与实战技巧 | 推荐配置目标 |
| :--- | :--- | :--- |
| **MSI Afterburner + RTSS** | 游戏内 OSD 监控（帧率、Frametime 帧时间曲线、显卡温度、显存占用）与**精准锁帧** | 开启 Frametime 曲线，将帧率锁定在显示器高刷减 3 帧（如 165Hz 锁 162 帧），获得平直无抖动帧生成时间。 |
| **LatencyMon** | 系统 DPC / ISR 中断延迟分析 | 查找导致电竞跳 Ping、瞬卡、音频爆音的驱动文件名（如 `nvlddmkm.sys`）。 |
| **Display Driver Uninstaller (DDU)** | 安全模式下 100% 连根拔起显卡旧驱动与注册表残留 | 解决换显卡后掉驱动、驱动降级或切独显黑屏问题。 |
| **Nvidia Profile Inspector** | N卡全局底层配置深挖 | 强制在不支持的游戏中开启 rBAR (Resizable BAR)、关闭微小的着色器调度瓶颈。 |
| **Custom Resolution Utility (CRU)** | 显示器 EDID 参数底层修改与超频 | 修复高刷外接屏黑屏、修改特定分辨率刷新率、重置显示设备缓存。 |

---

## 五、 场景四：程序员与开发者工作站必备 (Developer Workstation)

参考后端与全栈开发标准环境，构建轻量高效的生产力机器：

1. **终端与命令行基础设施**：
   - **Windows Terminal**（微软商店官方）：多标签、支持 PowerShell / WSL / Git Bash 无缝切换，支持 GPU 文本渲染加速；
   - **PowerShell 7 (pwsh)**：跨平台现代 PowerShell，性能远胜系统内置 5.1；
   - **Microsoft PowerToys**：微软官方极客效率工具箱（窗口高级分屏 FancyZones、全局取色器、键盘映射器、无损图片批量缩放）。
2. **代码编辑与版本控制**：
   - **Visual Studio Code**：轻量级代码编辑之王（必装：中文语言包、GitLens、Prettier、Path Intellisense）；
   - **Git for Windows**：版本控制底座，配置全局 `core.autocrlf = true`；
   - **GitHub Desktop**：图形化 Git 客户端，降低分支冲突与合并心智负担。
3. **本地虚拟化与容器**：
   - **WSL 2 (Windows Subsystem for Linux)**：安装 Ubuntu 24.04 LTS，享受与生产环境一致的原生 Linux 内核性能；
   - **Docker Desktop**：基于 WSL2 后端运行，隔离各类数据库与微服务容器。
4. **数据库与 API 测试**：
   - **DBeaver Community**：免费开源多数据库管理工具（全面支持 MySQL、PostgreSQL、Redis、SQLite）；
   - **Postman / Thunder Client**（VS Code 内置插件）：轻量级 RESTful API 调试与接口测试。

---

## 六、 场景五：系统重装、灾备救砖与维护软件

*   **万能启动 U 盘制作：Ventoy**
    *   **为什么必须用它**：彻底颠覆传统“一个 U 盘刻录一个镜像”模式。制作完成后，只需把官方 Windows 10/11、Ubuntu、PE 的 `.iso` 镜像像拷电影一样复制进 U 盘，开机即有多重引导菜单。
    *   ❌ **绝对红线**：严禁使用 大白菜、老毛桃、微PE盗版改版 等被注入劫持木马与强制捆绑流氓主页的第三方制作工具。
*   **微软原版系统写入：Rufus**
    *   **优势**：开源小巧，制作官方 Windows 11 安装介质时，能自动打勾**一键绕过硬件 TPM 2.0 / 安全启动要求**，并一键跳过强制联网与强制登录微软在线账户。
*   **Windows 官方镜像部署与备份：Dism++**
    *   **优势**：基于微软底层 DISM 架构的图形化神器，无需启动进入系统即可进行系统热备份（WIM/ESD）、驱动离线注入、更新补丁整合与启动引导自愈。

---

## 七、 常用软件防坑对比速查表

| 传统流氓/捆绑软件 (建议立刻卸载) | 推荐终极纯净平替 | 核心优势 |
| :--- | :--- | :--- |
| **鲁大师 / 驱动精灵 / 驱动人生** | **图吧工具箱 + 官网硬件驱动 + 厂商控制中心** | 零广告弹窗、不偷跑算力、硬件参数 100% 真实不造假 |
| **360压缩 / 好压 / 快压** | **NanaZip / 7-Zip** | 开源无广告、原生右键菜单、极低内存消耗 |
| **腾讯电脑管家 / 360安全卫士** | **Windows Defender + 火绒安全 (仅需弹窗拦截)** | 纯净静默，不抢占 CPU/GPU 游戏前台调度开销 |
| **迅雷下载器 (弹窗捆绑版)** | **Motrix / FDM (Free Download Manager)** | 基于 Aria2 内核、无多余后台驻留、开源清爽 |
| **暴风影音 / 爱奇艺播放器** | **PotPlayer / VLC Media Player** | 硬件全格式原画解码、支持 HDR 与多声道源码输出 |
| **各大流氓浏览器 (带资讯屏保)** | **Google Chrome / Microsoft Edge (关闭资讯)** | 纯粹快速、扩展生态丰富、零静默推流 |
