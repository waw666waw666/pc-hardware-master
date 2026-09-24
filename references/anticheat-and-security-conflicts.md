# 反作弊系统、虚拟化安全与开发者工具冲突手册 (Anti-Cheat & Virtualization Security Conflicts Guide)

本手册专为 AI Agent 诊断和调优 Windows 电脑的**游戏反作弊系统（Riot Vanguard、Easy Anti-Cheat、BattlEye、ACE）、Windows 11 安全基线（TPM 2.0、Secure Boot、VBS/HVCI 核心隔离）以及开发者工具环境冲突**提供精准排查指引。

---

## 一、四大主流反作弊系统架构与驻留特征

| 反作弊引擎 | 覆盖主流游戏 | 内核驱动与服务 | 关键特征与敏感点 |
| :--- | :--- | :--- | :--- |
| **Riot Vanguard** | 无畏契约 (VALORANT)、英雄联盟 (LoL 外服) | `vgk.sys` (内核驱动)<br>`vgc.exe` (用户态服务) | **开机即驻留内核**。对 Win11 的 TPM 2.0、Secure Boot 审查极为严苛，严禁测试签名模式。 |
| **Easy Anti-Cheat (EAC)** | APEX 英雄、堡垒之夜、艾尔登法环、战地 2042 | `EasyAntiCheat.sys`<br>`EasyAntiCheat_EOS.sys` | 随游戏启动加载。对第三方未签名驱动、内存完整性（HVCI）阻断极敏感。 |
| **BattlEye (BE)** | 绝地求生 (PUBG)、彩虹六号 (R6)、命运 2 | `BEDaisy.sys` (内核驱动)<br>`BEService.exe` | 深度监控句柄与内存注入。对常用开发调试工具（Process Hacker/CE）零容忍。 |
| **ACE (腾讯反作弊)** | 三角洲行动、英雄联盟国服、CFHD、无畏契约国服 | `AntiCheatExpert`<br>`SGuard64.exe` | 包含强力自保护驱动，与深信服/绿盟等企业级安全客户端可能存在微内核争抢。 |

---

## 二、高频报错代码穿透与秒级排解

### 1. 拳头 Vanguard 报错 `VAN 9003` (无法进入游戏)
- **底层根因**：Windows 11 操作系统强制要求开启 **UEFI Secure Boot (安全启动)**，否则 Vanguard 拒绝初始化。
- **只读检测命令**：
  ```powershell
  # 检查 Secure Boot 是否开启 (返回 True 为正常开启，False 为未开)
  Confirm-SecureBootUEFI
  ```
- **保姆级 BIOS 开启指导**：
  1. 重启电脑，开机连续敲击 `Del`（台式机/华硕/微星）或 `F2`（戴尔/联想/笔记本）进入 BIOS；
  2. 找到【Security】或【Boot】页面；
  3. 若有【CSM Support】（兼容支持模块），**必须先将其设为 Disabled (关闭)**；
  4. 找到【Secure Boot】（安全启动），将其切换为 **Enabled (开启)**；
  5. 按 `F10` 保存并重启电脑即可彻底消除 `VAN 9003`。

### 2. 拳头 Vanguard 报错 `VAN 1067`
- **底层根因**：主板固件的 **TPM 2.0 (受信任的平台模块)** 被关闭或未初始化。
- **系统排查**：
  按 `Win + R` 键，输入 `tpm.msc` 回车。查看状态是否为“TPM 已就绪，可以使用”，规范版本是否为 2.0。
- **BIOS 开启对应开关**：
  - **Intel 平台**：BIOS 中找到并开启 **Intel Platform Trust Technology (PTT)**；
  - **AMD 平台**：BIOS 中找到并开启 **AMD fTPM switch (Firmware TPM)**。

### 3. Vanguard 报错 `VAN -81` / `VAN 128` (连不上后台或驱动未加载)
- **底层根因 1：Windows 处于测试签名模式 (Test Mode)**
  - 排查命令：`bcdedit /enum {current}`
  - 现象：若输出中包含 `testsigning Yes`，Vanguard 会认定系统内核可加载任意未经微软签名的驱动而主动罢工；
  - 一键修复：以管理员身份运行 `bcdedit /set testsigning off`，重启电脑。
- **底层根因 2：`vgc` 系统服务未正常自启**
  - 一键修复：
    ```cmd
    sc config vgc start= demand
    net start vgc
    ```

---

## 三、Windows 内存完整性 (HVCI / 核心隔离) 与性能权衡

### 1. 原理与现象
Windows 11 的【内核隔离】->【内存完整性】(HVCI) 利用硬件虚拟化安全（VBS）技术，在虚拟化容器中对内核代码执行严格的代码完整性校验，防止恶意驱动篡改系统。

### 2. 常见痛点
1. **开关变灰或无法开启**：提示“不兼容的驱动程序阻断了内存完整性”。通常是老旧的风扇调速软件、老机械键盘驱动或旧版移动光驱驱动（如 `wdcsam64.sys`）未包含微软 WHQL 认证。
2. **电竞游戏性能损耗**：
   - 在较老架构 CPU（如 Intel 10/11 代、AMD Zen 2）上，开启 VBS/HVCI 会导致 CPU 在内核与安全虚拟层间频繁切换，产生 **3% ~ 8% 的帧率损耗与 1% Low 微卡顿**；
   - 在现代架构（Intel 12 代及以上、AMD Zen 4 及以上），得益于硬件虚拟化加速，性能损耗微乎其微（<1%）。

### 3. 只读检测状态
```powershell
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard | 
    Select-Object VirtualizationBasedSecurityStatus, SecurityServicesRunning
```

---

## 四、开发者工具与反作弊的“免误杀”共存法则

作为一名开发者，电脑中常驻有各种底层开发与抓包调试工具，极易触碰反作弊系统的防御警报：

1. **进程分析类工具（Process Hacker / Process Explorer）**：
   - 痛点：Process Hacker 附带的 `KProcessHacker.sys` 内核驱动具有极高权限，会直接被 EAC 和 BattlEye 判定为作弊驱动并强退游戏；
   - 对策：打游戏前彻底退出 Process Hacker，确保其内核服务已卸载。
2. **调试与逆向工具（Cheat Engine / x64dbg / IDA Pro / Fiddler）**：
   - 即使没有挂接游戏，某些反作弊（如 ACE、BE）会在游戏启动时枚举全局进程列表和最近运行注册表，检测到名字直接弹窗拒绝启动；
   - 对策：关闭相关进程，清理临时调试会话。
3. **代理工具（Clash / Mihomo / Sing-box 的 TUN 虚拟网卡模式）**：
   - 痛点：TUN 虚拟网卡会劫持全局 DNS 与 IP 路由。当反作弊服务器进行证书强校验时，若代理软件未配置绕过规则，会导致反作弊握手失败（报错 Untrusted system file 或 无法连接认证服务器）；
   - 对策：在代理工具中将反作弊域名及游戏可执行文件加入 **`DIRECT` 直连白名单**，绕过代理虚拟网卡。
