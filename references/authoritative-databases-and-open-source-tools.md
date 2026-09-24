# 全球权威基准数据库与 GitHub 开源硬件工具索引 (Authoritative Databases & Tools)

本手册专为 AI Agent 为用户进行硬件选型、防踩坑、芯片底层规格比对与工业级验机提供全球最公认的**开源工具项目、基准跑分数据库与权威评测机构导航**。

---

## 一、 GitHub 精选硬件开源项目与专业知识库

### 1. 硬件综合检测与性能天梯工具
*   **[luolangaga/tubatools (图吧工具箱)](https://github.com/luolangaga/tubatools)**
    - **定位**：中文 DIY 硬件圈公认最经典的开源硬件检测与维护工具箱；
    - **核心内容**：免安装绿色集成 CPU-Z、GPU-Z、AIDA64、FurMark（甜甜圈）、CrystalDiskInfo、MemTest 等核心测试软件；内置实测 CPU/GPU 性能天梯图；
    - **适用场景**：新机到手验机、二手硬件防翻车鉴别、烤机稳定性压力测试。
*   **[RtxTool (硬件工具归档箱)](https://github.com/Rtx8080Ti/RtxTool)**
    - **定位**：极客向硬件检测与调试软件收录库；
    - **核心内容**：归档了各代芯片性能排行、显示器坏点检测、音频驱动与超频辅助脚本。

### 2. 固态硬盘（SSD）芯片与颗粒权威库
*   **[the-m-a-x/ssd-guides (NewMaxx SSD Database)](https://github.com/the-m-a-x/ssd-guides)** 与 **[NewMaxx SSD Master Spreadsheet](https://ssd.borecraft.com/)**
    - **定位**：全球硬件界公认的固态硬盘全参数百科全书（由存储领域专家 NewMaxx 维护）；
    - **核心内容**：
      1. 涵盖全球市售千款 NVMe/SATA SSD 的真实主控型号（慧荣、群联、英韧、马牌、三星/自研）；
      2. 闪存颗粒类型（原厂正片、白片、降级划线片、TLC / QLC 颗粒与堆叠层数）；
      3. 缓存方案：是否有独立外置 DRAM 缓存（DDR4/LPDDR4）、容量大小，或采用 HMB（Host Memory Buffer）协议；
      4. SLC Cache 策略（全盘动态模拟 vs 固定容量）以及缓外持续写入真实速度。

### 3. 电源（PSU）质量梯队与避坑圣经
*   **[Cultists Network PSU Tier List](https://cultists.network/140/psu-tier-list/)** 与 **[SPL's PSU Tier List](https://www.reddit.com/r/buildapc/)**
    - **定位**：全球 PC DIY 社区公认的电源安全与品质分级圣经；
    - **核心分级**：
      - **Tier A（旗舰/高端）**：LLC 谐振 + DC-DC 架构，105℃ 全日系电容，纹波 < 20mV，具备完整的 OCP/OVP/UVP/SCP/OTP 电气保护，支持 ATX 3.0/3.1 原生 12V-2x6 接口，能抗住 200%-300% 瞬时尖峰功耗；
      - **Tier B（主流甜品）**：性能稳定、保护齐全，适合中高端单卡游戏平台；
      - **Tier C（经济入门）**：基础安全，适合核显或低功耗千元卡；
      - **Tier E / Tier F（高危避坑/炸弹级）**：单管/双管正激淘汰架构、劣质杂牌电容、虚标功率、保护机制缺失，极易炸机并击穿主板与显卡。

### 4. 组装兼容性与大模型硬件项目
*   **[PCPartPicker](https://pcpartpicker.com/)**：全球装机爱好者的配置校验核心。内置强大的物理尺寸与电气兼容性检查引擎（机箱显卡限长、散热器限高、内存马甲干涉、电源接口与预估功耗匹配）；
*   **[AgileWoW/deepseek-r1-hardware-guide](https://github.com/AgileWoW/deepseek-r1-hardware-guide)**：针对 DeepSeek-R1 / V3、Llama 3 等开源大模型的本地部署硬件选型与显存量化指南；
*   **[dortania/GPU-Buyers-Guide](https://github.com/dortania/GPU-Buyers-Guide)**：详述各代 AMD/NVIDIA/Intel GPU 的底层微架构演进、硬件编解码（AV1/HEVC/H.264）与电气供电规范。

---

## 二、 全球权威性能评测机构与基准数据库

1.  **[TechPowerUp GPU Database & CPU Database](https://www.techpowerup.com/)**
    - 全球最完整、最精确的芯片级规格档案库。收录每款芯片的核心面积（Die Size）、晶体管数量、流处理器/CUDA单元、ROP/TMU、基准/睿频、显存位宽与外部供电引脚测试。
2.  **[Tom's Hardware GPU & CPU Hierarchy](https://www.tomshardware.com/reviews/gpu-hierarchy,4388.html)**
    - 公认的标准硬件性能天梯榜。严格区分 1080p、2K、4K 三档分辨率，并在纯光栅性能与开启光追下分别打分，直观展现帧率断崖与阶梯差距。
3.  **[NanoReview](https://nanoreview.net/)**
    - 覆盖移动端（笔记本 CPU/移动显卡）与桌面端的综合跑分引擎，提供 Cinebench、Geekbench、3DMark、PCMark 等全维度能耗比比对。
4.  **国内深度评测与科普平台**：
    - **极客湾 (Geekerwan)**：底层微架构逆向剖析、移动端与桌面端能耗曲线、自研跨平台移动/桌面游戏性能测试集；
    - **硬件茶谈 (Hardware Tea Talk)**：工业级三维动画详解 CPU、显卡、主板芯片组、水冷、风道运作原理与实操避坑；
    - **超能网 (Expreview)**：工业级电源拆解测试（纹波、交叉负载、动态响应）、机箱风道风压风量风洞实验；
    - **Chiphell (CHH)**：顶级 DIY 水冷MOD、服务器级硬件、存储阵列与高端极客玩家交流社区。
