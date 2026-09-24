# 多厂商显卡驱动与专属图形优化手册 (Universal GPU Vendor & Driver Guide)

本手册专为 AI Agent 在遇到 **NVIDIA GeForce、AMD Radeon、Intel Arc** 等不同品牌独立显卡与核心显卡时提供专属驱动排查与性能配置方案。

---

## 一、NVIDIA GeForce 显卡全系排障标准

### 1. 驱动与控制中心
- **DCH 控制面板安装**：如果右键菜单无“NVIDIA 控制面板”，通过 `winget install --id 9NF8H0H7WMLT --source msstore` 补装，或执行 `ms-windows-store://pdp/?productId=9NF8H0H7WMLT`。
- **NVIDIA App**：英伟达新一代整合中心，整合驱动下载、性能监视器与 RTX 滤镜。

### 2. 关键驱动级 3D 参数
- **低延时模式 (Low Latency Mode)**：推荐设为 **超高 (Ultra)** 或 **开 (On)**（减少 CPU 排队帧，极大降低输入滞后）。
- **电源管理模式 (Power Management Mode)**：电竞电脑建议设为 **最高性能优先**（防止对局中核心降频）。
- **着色器缓存大小 (Shader Cache Size)**：建议设为 **10GB 或无限制**（防止缓存满后频繁覆盖旧缓存导致磁盘卡顿）。
- **Multiplane Overlay (MPO) 异常**：如果 Chrome、Discord 经常闪烁或全屏切屏黑屏，通过注册表禁用 MPO（`OverlayTestMode = 5`）。

---

## 二、AMD Radeon 显卡全系排障标准

### 1. 驱动控制中心：AMD Software: Adrenalin Edition
- **驱动类型**：AMD 官方 Adrenalin 驱动分为“仅驱动”、“精简安装”与“完整安装”。
- **常见踩坑：Windows Update 恶意静默降级 AMD 驱动！**
  - 表现：玩家打开 AMD 控制面板报 `Radeon Software and Driver versions do not match` 并报错闪退；
  - 根因：Windows Update 自动从微软服务器拉取了过时的公版驱动覆盖了玩家官网安装的 Adrenalin 驱动；
  - 对策：组策略开启“排除驱动程序更新”，并在设备管理器中“回滚显卡驱动”。

### 2. 关键图形功能优化与避坑
- **Radeon Anti-Lag (抗延迟)**：**开启**。降低输入延迟，原理类似 NVIDIA Reflex。
- **Radeon Chill (智降帧率)**：**电竞游戏严禁开启！** Chill 在玩家不动鼠标时会将帧率骤降到 30 FPS，突然开火时瞬间拉升，会导致剧烈顿挫！
- **Radeon Boost (动态分辨率加速)**：仅在低端显卡开启；中高端显卡开启会导致快速转头时画质模糊。
- **AMD SmartAccess Memory (SAM)**：必须在主板 BIOS 开启 `Above 4G Decoding` 与 `Resizable BAR`，A 卡开启后 1% Low 帧提升 5%~15%。
- **禁用 ULPS (Ultra Low Power State)**：
  - A 卡在睡眠唤醒或双屏模式下偶发黑屏死机，通过修改注册表 `EnableUlps = 0` 彻底消除显卡超低功耗休眠唤醒失败问题。

---

## 三、Intel Arc (锐炫) 独立显卡全系排障标准

### 1. 绝对强制要求：必须开启 Resizable BAR (rBAR)
- **底层死穴**：Intel Arc A580/A750/A770 等显卡在硬件设计上**极度依赖 Resizable BAR**。
- 如果主板 BIOS 未开启 rBAR，Arc 显卡的运行性能会直接**暴跌 30% 到 50%**，并在几乎所有游戏中出现严重的帧生成时间撕裂与掉帧。
- **排查命令**：在 Intel Arc Control 或 GPU-Z 中检查 Resizable BAR 是否为 `Enabled`。

### 2. DX9/DX11 老游戏优化
- Intel Arc 架构对原生 DX12/Vulkan 优化极佳，但原生 DX9 运行在翻译层（D3D9On12）。如果玩老游戏卡顿，可引导用户采用开源工具 `DXVK`（将 DX9/11 转为 Vulkan 渲染）获得翻倍帧率。
