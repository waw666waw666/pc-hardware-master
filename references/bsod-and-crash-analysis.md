# 蓝屏死机 (BSOD)、系统异常崩溃与转储日志分析手册 (BSOD & Crash Dump Diagnostic Guide)

本手册专为 AI Agent 诊断和分析 Windows 平台的**蓝屏死机（Blue Screen of Death）、自动黑屏重启（Kernel-Power 41）、游戏意外闪退（CTD）以及驱动崩溃**提供底层排查方案。

---

## 一、系统崩溃核心三步排查法

当用户反馈“我电脑老是蓝屏”、“玩着玩着突然重启或闪退”，绝大多数问题并非硬件彻底损坏，而是**特定驱动版本冲突、内存 XMP 时序不稳定或反作弊系统内核拦截**。

### 1. 抓取 Windows 崩溃转储文件 (Minidump)
Windows 在发生蓝屏时，会将发生崩溃瞬间的 CPU 寄存器与调用栈写入小内存转储文件：
- 路径：`C:\Windows\Minidump\*.dmp`
- **只读探测脚本**：
  ```powershell
  # 检查最近是否有蓝屏 Minidump
  Get-ChildItem -Path "C:\Windows\Minidump" -Filter "*.dmp" -ErrorAction SilentlyContinue | 
      Sort-Object LastWriteTime -Descending | 
      Select-Object -First 5 Name, Length, LastWriteTime
  ```

### 2. 检查系统关键事件日志（Kernel-Power 41）
排查是否发生断电式硬重启：
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Kernel-Power'; Id=41} -MaxEvents 5 -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Id, Message
```

---

## 二、电竞与日常高频蓝屏代码（BugCheck）速查与破案

| 蓝屏代码 (BugCheck) | 常见诱因驱动 | 核心根因与精准对策 |
| :--- | :--- | :--- |
| **`0x00000116`<br>VIDEO_TDR_FAILURE** | `nvlddmkm.sys`<br>`amdkmdag.sys` | **显卡响应超时与重置失败**。<br>1. 显卡核心电压不稳或瞬时过热；<br>2. 显卡驱动损坏。**对策**：用 DDU 在安全模式下彻底卸载显卡驱动后重装官网稳定版；关闭显卡高频超频。 |
| **`0x00000133`<br>DPC_WATCHDOG_VIOLATION** | `nvlddmkm.sys`<br>`storahci.sys`<br>网卡驱动 | **DPC 队列超时卡死**。<br>某驱动霸占中断超过系统阈值。**对策**：详见 `audio-and-dpc-latency.md`，将显卡电源管理设为最高性能优先，更新固态硬盘固件与网卡驱动。 |
| **`0x0000001A`<br>MEMORY_MANAGEMENT** | `ntoskrnl.exe` | **物理内存坏块或 XMP 超频不稳定**。<br>1. 内存 XMP 频率过高（如 7200MHz 缩缸或时序过紧）；<br>2. 内存金手指氧化或接触不良。**对策**：进 BIOS 暂时关闭 XMP 降回基础频率测试；运行 `mdsched.exe` 启动 Windows 内存诊断工具。 |
| **`0x0000007E` / `0x0000003B`<br>SYSTEM_THREAD_EXCEPTION** | 反作弊驱动<br>(`vgc.sys` / `BEDaisy.sys`) | **反作弊系统与系统驱动内核冲突**。<br>拳头 Vanguard 或育碧/APEX 易反作弊驱动发生内核缺页。**对策**：检查 BIOS 是否开启 TPM 2.0 与 Secure Boot（安全启动）；彻底重装反作弊客户端。 |
| **`0x0000009F`<br>DRIVER_POWER_STATE_FAILURE** | PCI Express 设备<br>外设驱动 | **休眠与唤醒电源状态转换失败**。<br>电脑从待机休眠唤醒时某 USB 外设或无线网卡拒绝恢复工作。**对策**：禁用 USB 选择性挂起；更新无线网卡与蓝牙驱动。 |

---

## 三、快速提取崩溃元凶驱动的 PowerShell 一行令

如果电脑上没有安装 WinDbg，AI 可以调用 PowerShell 直接读取 Minidump 的二进制特征字符串定位嫌疑 `.sys`：
```powershell
$latestDump = Get-ChildItem "C:\Windows\Minidump\*.dmp" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestDump) {
    # 提取转储文件中包含的常见硬件故障驱动名
    $dumpText = [System.IO.File]::ReadAllText($latestDump.FullName, [System.Text.Encoding]::ASCII)
    $sysMatches = [regex]::Matches($dumpText, '\b[a-zA-Z0-9_\-]{3,25}\.sys\b') | ForEach-Object { $_.Value } | Group-Object | Sort-Object Count -Descending | Select-Object -First 5
    $sysMatches | Select-Object @{n="SuspectDriver";e={$_.Name}}, @{n="Frequency";e={$_.Count}}
}
```
*(通过该方法，AI 可以在数秒内告诉用户崩溃具体是由哪个硬件驱动引发)*
