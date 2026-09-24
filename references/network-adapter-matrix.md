# 全品牌网卡硬件与防跳 Ping / 防断网适配手册 (Universal Network Adapter Matrix)

本手册专为 AI Agent 针对不同网卡品牌（**Intel、Realtek 瑞昱、MediaTek 联发科、Qualcomm 高通**）的无线 Wi-Fi 与有线以太网卡提供精准的低延迟与抗断连参数调优。

---

## 一、Intel 网卡系列 (Wi-Fi 6/6E/7 与 I225/I226 2.5G 有线)

### 1. Intel 无线网卡（AX200, AX201, AX210, AX211, BE200 等）
- **核心调优指令**：
  ```powershell
  # 锁定漫游为最低，防止后台静默搜热点导致跳 Ping (100~300ms 脉冲)
  Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'RoamAggressiveness' -RegistryValue '1' -ErrorAction SilentlyContinue
  # 关闭 MIMO 节能休眠，保持天线全速唤醒
  Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'MIMOPowerSaveMode' -RegistryValue '0' -ErrorAction SilentlyContinue
  # 关闭数据包合并批处理，实现游戏 UDP Tick 零延迟投递
  Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword '*PacketCoalescing' -RegistryValue '0' -ErrorAction SilentlyContinue
  # 开启吞吐量增强
  Set-NetAdapterAdvancedProperty -Name 'WLAN' -RegistryKeyword 'ThroughputBoosterEnabled' -RegistryValue '1' -ErrorAction SilentlyContinue
  ```

### 2. Intel 2.5G 有线网卡（I225-V / I226-V）“神秘断网 1 秒”通病
- **典型症状**：插网线玩游戏时，偶尔右下角网卡变成地球图标断网 1~2 秒，随后自动连上（游戏掉线）。
- **根因**：Intel 2.5G 控制器与部分路由器/交换机的 **EEE（Energy Efficient Ethernet / 节能以太网）** 握手异常。
- **对策**：在有线网卡属性中**禁用「节能以太网」与「超轻量节能」**。

---

## 二、Realtek 瑞昱小螃蟹系列 (RTL8852 Wi-Fi 6 与 RTL8125 2.5G)

### 1. Realtek 无线网卡（RTL8821CE, RTL8822CE, RTL8852AE/BE/CE）
- **常见问题**：出厂驱动过于激进地进入睡眠省电模式，导致突发性丢包；
- **自适应调优**：
  - 禁用 `Power Saving Mode (省电模式)`；
  - 禁用 `WMM PS`；
  - 将 `Roaming Aggressiveness` 设置为 `Disable` 或 `Lowest`。

### 2. Realtek 2.5G 有线网卡（RTL8125 / RTL8125BG）
- **禁用三大省电杀手**：
  - **节能以太网 (Energy Efficient Ethernet)** -> 设为 **禁用 (Disabled)**；
  - **环保节能 (Green Ethernet)** -> 设为 **禁用 (Disabled)**；
  - **高级 EEE (Advanced EEE)** -> 设为 **禁用 (Disabled)**。
  *(关掉后网卡不再发生电压步进导致的短暂断包)*

---

## 三、MediaTek 联发科网卡 (MT7921, MT7922 / AMD RZ608, RZ616)

联发科网卡广泛装备在华硕天选、联想拯救者等 AMD 锐龙游戏本上：
- **最大历史通病：设备管理器中“网卡神秘消失（代码 10 / 代码 43）”**！
  - 症状：电脑休眠或开机后突然没有 Wi-Fi 选项，设备管理器里网卡带黄色叹号；
  - 根因：主板 PCIe 电源管理与网卡固件冷启动握手超时；
  - **应急自救**：拔掉电源适配器，**长按笔记本开机电源键 30 秒（释放主板静态残余电荷/EC复位）**，再重新开机即可 100% 重新唤醒网卡；
- **日常抗延迟优化**：
  - 必须在设备管理器 -> 网卡属性 -> 电源管理 -> **取消勾选「允许计算机关闭此设备以节约电源」**。
