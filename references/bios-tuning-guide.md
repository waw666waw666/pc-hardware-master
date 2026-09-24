# 主板 BIOS 底层调参与极客性能优化手册 (BIOS Tuning Guide)

本文档面向进阶硬件玩家，提供基于主流主板平台（华硕、微星、技嘉、华擎）的底层微码与电气参数微调工程标准。

---

## 1. AMD PBO2 (Precision Boost Overdrive 2) + Curve Optimizer (CO) 调校

### 1.1 原理与核心目标
*   AMD 动态睿频算法受三大功耗墙限制：**PPT（总封装功耗限制）、TDC（持续电流限制）、EDC（瞬时峰值电流限制）**。
*   Curve Optimizer 通过对不同核心的电压/频率曲线（V/F Curve）施加负向电压偏移（Negative Offset），让 CPU 在相同发热量下冲击更高全核与单核睿频。

### 1.2 逐核微调标准 SOP
1.  **准备阶段**：
    *   在 Windows 安装 **Ryzen Master**，记录芯片中标记为“金星（Gold Core）”和“银星（Silver Core）”的核心编号；
    *   下载 **CoreCycler**（GitHub 开源单线程压测脚本）。
2.  **BIOS 设置步骤**：
    *   进入 BIOS -> `Advanced` -> `AMD Overclocking` -> `Precision Boost Overdrive` 设为 `Advanced`；
    *   `PBO Limits` 设为 `Motherboard`（或手动设定 PPT 120W, TDC 80A, EDC 120A 防止过热）；
    *   `Curve Optimizer` 设为 `Per Core`（按核独立设置）；
    *   **设置负压数值规则**：
        *   **金星 / 银星核心（体质最好）**：保守起步，设置负压 `-10 ~ -15`（防止待机瞬态欠压黑屏）；
        *   **其余普通体质核心**：设置负压 `-20 ~ -30`。
3.  **稳定性压测与黑屏判定**：
    *   运行 CoreCycler 逐核跑 Prime95 SSE / AVX2，每个核心测试 6~10 分钟；
    *   若测试到 Core 2 时电脑瞬间蓝屏或直接黑屏重启，进入 BIOS 将 Core 2 的负压回调 3~5 点（如从 -25 改为 -20）；
    *   直至所有核心无报错通过完整轮次。

---

## 2. Intel AC/DC Loadline 阻抗匹配与 CEP 降压方案

### 2.1 降压不降频的核心法则
*   直接在 BIOS 中设置 CPU Core Voltage Offset（如 -0.1V）会触发 **CEP（Current Excursion Protection）**，主板误判欠压而强制插入空指令，导致 Cinebench 跑分暴跌 30% 以上。
*   **最佳方案：通过调降 AC Loadline 降低主板请求的真实 VID。**

### 2.2 操作步骤（以微星 / 华硕 BIOS 为例）
1.  进入 BIOS 超频菜单，将 **CPU 电压模式**保持为 `Auto` 或 `Adaptive`；
2.  找到 **IA CEP (Current Excursion Protection)**，保持为 `Enabled`（追求系统最高电气安全）；
3.  找到 **IA AC Loadline** 与 **IA DC Loadline**（单位为毫欧 mΩ 或 1/100 mΩ）：
    *   主板默认 AC Loadline 通常偏高（如 1.1mΩ 或 90/110）；
    *   将 **IA AC Loadline 逐步调降**（如从 1.1mΩ 调降至 **0.3mΩ ~ 0.5mΩ**）；
    *   将 **IA DC Loadline** 与主板当前的防掉压等级（LLC）阻抗设为严格一致（例如微星 LLC Mode 4 对应 DC 0.5mΩ；华硕 LLC 4 对应 DC 0.98mΩ）；
4.  保存重启进入系统，运行 Cinebench R23 多核测试：
    *   观察 HWiNFO64 中 CPU 核心电压是否从默认 1.35V+ 下降至 1.22V~1.25V；
    *   CPU 温度下降 15℃~20℃；
    *   **多核跑分不发生折损（甚至因摆脱温度墙轻微上涨）**。

---

## 3. DDR5 内存次级时序（Sub-timings）手工收紧实操

> 适用硬件：海力士 A-die / M-die 颗粒（以 6000MHz ~ 6400MHz 为基准）

| 参数名称 | BIOS 缩写 | 主板默认 Auto 值 | 极客收紧推荐值 | 性能收益与注意事项 |
| :--- | :--- | :--- | :--- | :--- |
| **刷新间隔** | `tREFI` | 260 ~ 350 | **32767 ~ 65535** | **1% Low 帧提升最大项**。内存温度超 50℃ 易蓝屏，必须加风扇 |
| **刷新周期** | `tRFC` | 800+ (300ns) | **380 ~ 440 (120~140ns)** | 显著降低流水线停顿时间，发热量轻微上升 |
| **四激活窗口**| `tFAW` | 32 ~ 40 | **16 ~ 20** | 4 拍之内允许打开的激活行上限 |
| **读到预充电**| `tRTP` | 12 ~ 16 | **12** | 快速释放读取行，缩减访问等待 |
| **写到读延迟**| `tWTRL / tWTRS` | Auto | **16 / 4** | 读写频繁交替时的换向时延大幅收窄 |

---

## 4. 秒开机与休眠稳定性：MCR 与 Power Down 联动

*   **问题表象**：开启 XMP/EXPO 后，每次冷开机主板 DRAM 灯亮 60~90 秒甚至更久才进系统。
*   **根因**：DDR5 每次开机都在执行 MRC 读写眼图扫描与阻抗训练。
*   **标准化配置**：
    1. 在 BIOS 中找到 **`Memory Context Restore (MCR)`** -> 设为 **`Enabled`**；
    2. 紧接着找到 **`Power Down Enable` (掉电模式)** -> **必须强制设为 `Enabled`**（严禁设为 Auto 或 Disabled）；
    3. **原因**：若只开 MCR 而关闭 Power Down，在进入 S3 睡眠唤醒或内存空闲切入低功耗时，会由于时钟信号失步直接触发蓝屏死机；两者双开方能保证 10 秒快速开机且绝对稳定。

---

## 5. 风扇曲线优化（防止“反复起飞”风噪）

*   **常见病因**：CPU 打开网页或启动程序瞬间，温度瞬间突刺至 75℃，机箱风扇转速瞬间飙升至 100% 呼啸，随后几秒又归于平静，造成极烦人的忽快忽慢噪音。
*   **调谐法则**：
    1. **控制模式**：所有 4-Pin 风扇必须在 BIOS 中明确指定为 **PWM 脉宽调制模式**（严禁设为 DC 直流调压模式）；
    2. **温度源选择**：机箱出风与前置风扇的温度传感器推荐绑定为 **PCIe / VRM / 芯片组温度**，避免跟随 CPU 核心瞬时突跳；
    3. **启用温度平滑迟滞（Step Up / Step Down Hysteresis）**：
       - `Fan Step Up Time`（升速延迟）设为 **1.5s ~ 2.0s**（过滤短于 2 秒的瞬间温度突刺，风扇不随瞬间打开软件而盲目拉高转速）；
       - `Fan Step Down Time`（降速延迟）设为 **3.0s ~ 5.0s**（温度回落后缓慢降速，保持听感线性平滑）。
