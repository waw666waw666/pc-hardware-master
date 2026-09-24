# Windows 系统组件损坏、DISM 官方自愈与无损修复手册 (Windows Corruption & System Repair Guide)

本手册专为 AI Agent 诊断和指导 Windows 电脑的**系统文件损坏、设置闪退打不开、搜索栏转圈失灵、Windows Update 错误代码（`0x80070002` / `0x800f081f`）、DLL 坏映像报错以及无损就地升级（In-Place Upgrade）救砖**提供微软官方标准自愈方案。

---

## 一、系统损坏与暗病典型症状

当用户反馈以下“灵异系统故障”时，通常是 Windows 底层组件库（WinSxS）或系统受保护二进制文件因意外断电、磁盘坏块或第三方流氓清理工具误杀导致损坏：
1. **Windows 原生界面瘫痪**：点击“开始菜单”、“设置”或“任务栏搜索”没有任何反应或闪退；
2. **DLL 坏映像报错**：启动软件或游戏时弹出 `0xC000012F` 坏映像错误（Bad Image）；
3. **Windows Update 卡死报错**：系统更新反复失败，报错 `0x80070002`、`0x80070490` 或 `0x800f081f`（源文件未找到）；
4. **资源管理器右键崩溃**：右键点击文件时 `explorer.exe` 瞬间崩溃重启。

---

## 二、微软官方黄金自愈三部曲 (Standard 3-Step Self-Healing)

许多用户甚至初级技术人员习惯一上来就运行 `sfc /scannow`，但经常遭遇“Windows 资源保护找到了损坏文件但无法修复其中某些文件”的窘境。

### 顺序铁律：必须先修复底层组件库 (DISM)，再修复系统文件 (SFC)！
`sfc /scannow` 修复损坏文件时，必须从 `C:\Windows\WinSxS` 组件库中提取纯净的原始副本。如果底层组件库本身已经损坏，SFC 根本无米下锅！

以管理员身份打开 CMD 或 PowerShell，严格按序执行：

```cmd
:: 1. 扫描组件存储是否发生损坏
Dism /Online /Cleanup-Image /ScanHealth

:: 2. 检查组件存储的损坏标记状态
Dism /Online /Cleanup-Image /CheckHealth

:: 3. 联机调用微软官方云端更新源，自动修复受损的组件库
Dism /Online /Cleanup-Image /RestoreHealth

:: 4. 底层组件库纯净后，执行全盘受保护系统文件校验与替换
sfc /scannow
```

---

## 三、网络受阻时的离线 ISO 救砖绝招 (Offline Source Repair)

若因代理网络问题或局域网隔离无法连接微软 Windows Update 服务器，导致 `Dism RestoreHealth` 卡在 62.3% 报错“源文件未找到”：

1. 双击挂载与当前系统版本一致的官方 Windows 11 ISO 镜像文件（假设挂载后盘符为 `E:` 盘）；
2. 查看镜像内的版本索引编号：
   ```cmd
   dism /Get-WimInfo /WimFile:E:\sources\install.wim
   ```
   *(找到当前电脑对应的版本，例如专业版通常为索引 1 或 3)*
3. **强制指定本地挂载镜像为离线修复源**：
   ```cmd
   Dism /Online /Cleanup-Image /RestoreHealth /Source:WIM:E:\sources\install.wim:1 /LimitAccess
   ```
   *(本地直读光盘镜像，100% 极速自愈)*

---

## 四、终极无损救砖方案：原位就地升级 (In-Place Upgrade)

> [!IMPORTANT] 保护开发环境的最后一道神级防线
> 很多用户遇到顽固系统系统暗病时，往往被路人误导“格式化 C 盘重装系统”，导致精心配置的开发环境、Node/Python 虚拟环境、Docker 镜像、Git 凭据和几十款专业软件全部丢失，重建代价极其沉重！
> 
> 微软官方提供的 **“原位就地升级（In-Place Upgrade / Repair Install）”** 可以在**100% 完整保留个人数据、桌面所有已安装软件和注册表环境**的前提下，对操作系统进行彻底的“换心手术”！

### 保姆级操作指引：
1. 从微软官网下载最新的 **Windows 11 磁盘映像 (ISO)**；
2. 在当前运行的 Windows 桌面下，右键该 ISO 文件选择【装载】；
3. 双击运行虚拟光驱根目录下的 **`setup.exe`**；
4. 在向导中点击【更改安装程序下载更新的方式】-> 选择【不是现在】（节省时间）；
5. **最核心确认画面**：确保安装向导显示 **【保留个人文件和应用】**（若该选项为灰，说明下载的 ISO 语言或版本与当前系统不匹配，切勿继续）；
6. 点击【安装】，电脑将在后台重新刷入一套 100% 崭新且健康的 Windows 内核文件；
7. 几十分钟后重启进入系统：所有之前的系统闪退、搜索失灵、更新报错彻底消失，而你的开发环境和软件全部安然无恙！
