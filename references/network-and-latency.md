# 游戏网络低延迟、Wi-Fi 防跳 Ping 与网络调度手册 (Network & Latency Optimization Guide)

本手册专为 AI Agent 排查 Windows 平台下在线多人竞技游戏中的**高延迟、突发性跳 Ping（Lag Spikes）、瞬间丢包回弹**以及网络协议栈节流提供系统级解决方案。

---

## 一、Wi-Fi 无线网络周期性跳 Ping 的物理根因（Intel AX 系列网卡专治）

### 1. 现象描述
玩家明明坐在离路由器 2 米远的地方，信号满格，平日测速正常，但每隔 1~2 分钟，游戏延迟就会突然从正常的 `18 ms` 飙升至 `200~300 ms`，甚至出现“人物原地滑步/瞬移”，持续 1~2 秒后恢复。

### 2. 根因剖析：Intel 网卡后台漫游主动扫描（Roaming Scan）
以主流游戏本标配的 **Intel Wi-Fi 6 AX200 / AX201 / AX210 / AX211 / BE200** 为例：
- **漫游主动性 (RoamAggressiveness)**：驱动出厂默认设为 `3. 中等`。
- **机制**：哪怕当前 Wi-Fi 信号极佳，网卡固件也会定时在后台发送探测帧（Probe Request），逐个频道扫描周边是否有信号更好的路由器/节点。
- **代价**：当网卡离开当前频道去扫描其他信道时，当前游戏对局传输瞬间被阻塞（暂停收发包数秒），在对局中直观表现为 **突发性断崖式跳 Ping / 丢包**。

### 3. Intel 无线网卡四大电竞级底层参数调优
通过 PowerShell 直接修改网卡高级硬件属性：
```powershell
# 1. 漫游主动性设为「1. 最低」(Lowest)
# 只要不断连，网卡死锁当前路由，彻底杜绝后台定时搜网造成的跳 Ping
Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'RoamAggressiveness' -RegistryValue '1'

# 2. MIMO 节电模式设为「无 SMPS」(No SMPS)
# 彻底关闭天线省电睡眠模式，保持天线双发双收常驻工作，消灭射频唤醒延迟
Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'MIMOPowerSaveMode' -RegistryValue '0'

# 3. 禁用数据包合并 (*PacketCoalescing = 0)
# 默认开启是为了省电，把多个小包积攒在一起批量处理。打游戏需要实时接收 Tick，必须禁用批处理
Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword '*PacketCoalescing' -RegistryValue '0'

# 4. 开启吞吐量增强 (ThroughputBoosterEnabled = 1)
# 允许网卡在 802.11 传输中开启数据包突发传输机制（Packet Bursting）
Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'ThroughputBoosterEnabled' -RegistryValue '1'
```

---

## 二、Windows 多媒体系统调度与网络限流机制（NetworkThrottlingIndex）

### 1. Windows 的隐形限流机制
从 Windows Vista/7 延续至今的机制：
- 注册表路径：`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile`
- **`NetworkThrottlingIndex`（网络节流索引）**：默认值通常为 `10`。
  - **机制**：Windows 为了防止大流量网络下载抢占过多元器件算力导致系统卡顿，对非多媒体应用程序的网络数据包处理频率实施了人为限速。
  - **对策**：将其改为 `0xFFFFFFFF`（4294967295），彻底关闭 Windows 的网络包限速节流机制，释放全速网络中断处理能力。
- **`SystemResponsiveness`（系统响应保留）**：默认值通常为 `20`。
  - **机制**：Windows 默认永远强制保留 20% 的 CPU 周期给后台低优先级服务，防止后台程序完全饿死。
  - **对策**：将其改为 `0`，命令系统调度器将 100% 的 CPU 响应能力全部倾斜给前台运行的游戏进程。

### 2. 标准修改命令
```powershell
$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
Set-ItemProperty -Path $path -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord
Set-ItemProperty -Path $path -Name "SystemResponsiveness" -Value 0 -Type DWord

$taskPath = "$path\Tasks\Games"
Set-ItemProperty -Path $taskPath -Name "Scheduling Category" -Value "High" -Type String
Set-ItemProperty -Path $taskPath -Name "Priority" -Value 6 -Type DWord
Set-ItemProperty -Path $taskPath -Name "SFIO Priority" -Value "High" -Type String
```

---

## 三、TCP 延迟确认（Nagle 算法与 Delayed ACK）

### 1. 为什么打游戏需要关闭延迟确认？
- 标准 TCP 协议（RFC 1122）为节省网络带宽，默认启用“延迟确认（Delayed ACK）”：收到一个数据包后，不立即回复确认包（ACK），而是等待最多 200ms，看是否有后续数据一起打包回复。
- 在网络游戏中，游戏客户端需要毫秒级确认服务器下发的指令。这 200ms 的等待会导致端到端数据传输产生微小滞后。
- 将 `TcpAckFrequency` 设为 `1`，`TCPDelAckTicks` 设为 `0`，可让系统每收到一个 TCP 数据包立刻回复 ACK，大幅提升 TCP 链路的瞬时响应能力。

---

## 四、虚拟网卡与代理软件的排查纪律（开发者电脑特别注意！）

在开发机上，通常共存着多种虚拟网卡：
- **Docker Desktop** (`vEthernet (WSL)`)
- **VMware Workstation** (`VMnet1`, `VMnet8`)
- **Tailscale** (`Tailscale Tunnel`)
- **代理工具** (`Mihomo` / `Clash` / `V2Ray` 的 TUN 虚拟网卡)

### 避坑军规：
1. **严禁无脑批量禁用虚拟网卡**：不能因为网络有问题就让用户去停用 Docker 或 VMware 的网卡，这会直接击垮开发工作流；
2. **警惕 TUN 模式全量代理游戏流量**：
   - 很多开发者在本地挂着代理（如 Mihomo / Clash 的 TUN 模式）。
   - 如果代理规则配置不当，将国内国服游戏（如腾讯服无畏契约、国服英雄联盟）的流量误转发到了境外节点，会直接导致对局延迟暴增至几百毫秒甚至封号；
   - **排查方法**：提醒用户在打国服游戏时，将代理软件切换为“规则模式”或在游戏期间暂时断开全局 TUN 转发。
