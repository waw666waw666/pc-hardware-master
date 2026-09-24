# 全球主流 PC 硬件品牌、模具策略与性能模式全景矩阵 (Universal PC Vendor & Hardware Matrix)

本手册专为 AI Agent 在**任意品牌、任意架构的 Windows PC（联想、戴尔、华硕、惠普、微星、宏碁、七彩虹、机械革命、DIY 组装台式机）**上执行排障时提供**全自动品牌特征识别与自适应处置策略**。

---

## 一、PC 物理形态与品牌指纹自动识别逻辑

AI 在排查系统前，必须首先调用脚本判定目标机器的 **物理形态（台式机 vs 笔记本）** 与 **品牌模具**，严禁使用单一品牌的思维去套用其他机器。

### 1. 台式机 (Desktop) vs 笔记本 (Laptop) 判定
- **台式机特征**：无内置电池、无嵌入式控制器（EC）调光、显示器通过独立 DP/HDMI 线缆直接插在显卡挡板上。
  > ⚠️ **台式机第一高发人类迷惑故障：显示器插错口！**  
  > 很多台式机用户反馈“买了 4070 为什么打游戏只有 20 帧”，90% 是把显示器高清线（DP/HDMI）插到了**主板后置 I/O 接口（核显接口）**，而不是插在下方的**独立显卡挡板接口**上！
- **笔记本特征**：内置电池、内屏通过 eDP 排线连接、存在混合输出/独显直连 MUX 切换、物理背光通过主板 EC 控制、存在厂商私有的电源功耗模式快捷键。

---

## 二、全球主流笔记本品牌全景矩阵 (Brand-Specific Matrix)

| 品牌与主打系列 | 独显直连/双显卡切换方案 | 性能狂暴快捷键 | 官方控制软件 | 推荐纯净替代方案 / 常见特有 Bug |
| :--- | :--- | :--- | :--- | :--- |
| **联想 (Lenovo)**<br>拯救者 (Legion) / 小新 / GeekPro | 联想 Vantage -> 独显模式 (dGPU)<br>或 BIOS 开启 Discrete Graphic | **`Fn + Q`**<br>(蓝:安静 / 白:平衡 / 红:野兽) | Lenovo Vantage | **强烈推荐替代品：`Legion Toolkit`**（开源、零后台驻留、内存占用仅 20MB，彻底替代几百兆满地遥测的 Vantage）。 |
| **戴尔 (Dell) / 外星人**<br>G15, G16, Alienware m/x | NVIDIA 控制面板 DDS 动态切换<br>或 BIOS 开启 Direct Graphics | **`F9` (G 模式)**<br>外星人: **`F1`** | Alienware Command Center (AWCC) | **特有通病**：切独显直连后内屏 PWM 背光与 Windows 滑块断联，须用 `F6/F7` 硬件键调光；AWCC 经常卡载入或导致 DPC 延迟升高。 |
| **华硕 (ASUS) / ROG / 天选**<br>天选, 魔霸, 幻, 枪神 | 奥创中心 -> 显卡模式设为“独显直连”<br>(Ultimate Mode) | **`Fn + F5`**<br>(静音/性能/增强) | Armoury Crate (奥创中心) | **强烈推荐替代品：`G-Helper`**（GitHub 顶流开源神作，彻底卸载卡顿且死机频发的奥创中心，大幅降低系统中断延迟）。 |
| **惠普 (HP)**<br>暗影精灵 (OMEN) / 光影精灵 (Victus) | OMEN Gaming Hub -> 显卡切换器<br>选择“独显” | OMEN 专用快捷键 | OMEN Gaming Hub | **特有通病**：温控传感器过敏（暗影精灵黑屏门/防跌落传感器误触发），风扇狂转或瞬间锁 0.79GHz。 |
| **微星 (MSI)**<br>泰坦, 绝影, 神枪, 刃 | MSI Center -> 显卡模式切换 -> 独显直连 | **`Fn + F7`** 或 Cooler Boost (风扇一键最大) | MSI Center / Dragon Center | 注意切换直连必须重启电脑生效。 |
| **宏碁 (Acer)**<br>掠夺者 (Predator) / 暗影骑士 (Nitro) | NitroSense -> 独显直连 (需重启) | **物理 `Turbo` 按键** 或 NitroSense | PredatorSense / NitroSense | 开启 Turbo 按键后一键解锁激进功耗与最高风扇转速。 |
| **机械革命 (MECHREVO)**<br>极光, 旷世, 蛟龙 | 控制中心 -> 独显直连模式 | **电源键旁物理切换开关** 或 `Fn + F1` | MECHREVO Control Center | 注意功耗墙设置容易在休眠唤醒后重置为办公模式（35W）。 |

---

## 三、CPU 厂商与微架构自适应策略

AI 必须根据检测到的 CPU 架构动态调整调度策略：

### 1. Intel 异构大小核架构 (12/13/14 代 Core)
- **特征**：`P-Core (性能核)` + `E-Core (能效核)`。
- **自适应动作**：
  1. 必须确保 Windows 11 `AutoGameModeEnabled = 1`（唤醒 Thread Director 正确识别游戏）；
  2. 解锁「卓越性能」计划消除核心停车（Core Parking）唤醒延迟；
  3. 检查游戏是否启用了“多线程渲染”。

### 2. Intel 传统均质多核架构 (6 至 11 代 Core)
- **特征**：全大核设计，无异构调度开销。
- **自适应动作**：重点排查硅脂干涸引发的过热降频、清理后台多余常驻进程。

### 3. AMD Ryzen X3D 系列 (5800X3D, 7800X3D, 7950X3D)
- **特征**：配备巨大的 3D V-Cache 缓存，电竞帧率天花板。
- **自适应动作**：
  - 双 CCD 型号（如 7950X3D / 7900X3D）：必须确保安装了官方 AMD 芯片组驱动中的 **`AMD 3D V-Cache Performance Optimizer`** 服务，防止游戏线程跳到没有大缓存的副 CCD 上；
  - 必须开启 Windows 游戏模式，系统会自动将非缓存核心休眠（Parking），把游戏全部分配给带 3D 缓存的核心。

### 4. AMD Ryzen 标准多核架构 (Zen 2/3/4/5)
- **特征**：依赖 CPPC（协同能效与性能控制）调度首选核心（Preferred Cores）。
- **自适应动作**：安装官方芯片组驱动，激活 UEFI 中的 PBO（Precision Boost Overdrive）。

---

## 四、DIY 组装台式机专项排障排查项

如果是台式机用户反馈“打游戏卡/帧率低/配置浪费”：
1. **显卡线连接口排查**：问用户显示器连接线接在机箱上方（主板）还是下方（独显）；
2. **内存 XMP / EXPO 状态**：
   - 很多用户买了 6000MHz 甚至 7200MHz 的高频内存，装机后从未在 BIOS 开启 XMP/EXPO，全程运行在 4800MHz JEDEC 默认起步频率；
   - 内存带宽骤降 30%，直接导致电竞游戏 1% Low 惨烈下跌；
3. **PCIe 运行速率与通道**：
   - 检查显卡是否插在离 CPU 最近的第一根 PCIe x16 插槽；有些用户误插在下方的南桥 PCIe x4 插槽，带宽受限导致卡顿；
4. **Resizable BAR (rBAR) 状态**：
   - 检查 BIOS 是否开启 `Above 4G Decoding` 与 `Resizable BAR`，允许 CPU 一次性访问全部显存。
