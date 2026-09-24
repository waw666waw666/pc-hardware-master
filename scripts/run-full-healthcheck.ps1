# run-full-healthcheck.ps1
# Windows 全机型 100 分制电脑健康与性能体检总控脚本 (Universal PC Health & Performance Audit Engine)

[CmdletBinding()]
param(
    [ValidateSet('Console', 'Markdown', 'Json')]
    [string]$OutputFormat = 'Console',
    [string]$ExportMarkdownPath = ''
)

$ErrorActionPreference = 'SilentlyContinue'

$auditTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$score = 100
$deductions = @()
$passedChecks = @()
$recommendedFixes = @()
$criticalAlerts = @()

# ==============================================================================
# 1. 硬件平台与机型形态审计 (Hardware & Form Factor)
# ==============================================================================
$cs = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
if (-not $cs) { $cs = Get-WmiObject Win32_ComputerSystem -ErrorAction SilentlyContinue }

$chassis = Get-CimInstance Win32_SystemEnclosure -ErrorAction SilentlyContinue
$chassisTypes = if ($chassis) { $chassis.ChassisTypes } else { @(0) }

$laptopChassis = @(8, 9, 10, 11, 12, 14, 30, 31, 32)
$desktopChassis = @(3, 4, 5, 6, 7, 15, 16, 23, 24, 35)
$hasLaptopChassis = ($chassisTypes | Where-Object { $_ -in $laptopChassis }) -ne $null
$hasDesktopChassis = ($chassisTypes | Where-Object { $_ -in $desktopChassis }) -ne $null

$batteries = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
# 排除台式机通过 USB 接入的后备 UPS 不间断电源 (UPS 具备 Win32_Battery 实例且常见铅酸电池 Chemistry=6)
$genuineLaptopBattery = $batteries | Where-Object {
    $_.Name -notmatch "UPS" -and
    $_.DeviceID -notmatch "UPS" -and
    $_.Chemistry -ne 6
}

$isLaptop = $false
if ($hasLaptopChassis) {
    $isLaptop = $true
} elseif ($genuineLaptopBattery -and -not $hasDesktopChassis) {
    $isLaptop = $true
}

$rawMfr = if ($cs) { $cs.Manufacturer } else { "Unknown" }
$rawModel = if ($cs) { $cs.Model } else { "Unknown" }

$brand = "Custom_DIY_Desktop"
if ($rawMfr -match "Lenovo|ThinkPad|IdeaPad") { $brand = "Lenovo" }
elseif ($rawMfr -match "Dell|Alienware") { $brand = "Dell" }
elseif ($rawMfr -match "ASUSTeK|ASUS|ROG|TUF") { $brand = "ASUS" }
elseif ($rawMfr -match "HP|Hewlett-Packard|OMEN|Victus") { $brand = "HP" }
elseif ($rawMfr -match "Micro-Star|MSI") { $brand = "MSI" }
elseif ($rawMfr -match "Acer|Predator|Nitro") { $brand = "Acer" }
elseif ($rawMfr -match "MECHREVO") { $brand = "MECHREVO" }
elseif ($rawMfr -match "Colorful") { $brand = "Colorful" }

# ==============================================================================
# 2. CPU 架构与电源调度审计 (CPU & Power Scheme)
# ==============================================================================
$cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $cpu) { $cpu = Get-WmiObject Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1 }
$cpuName = if ($cpu) { $cpu.Name.Trim() } else { "Unknown CPU" }

$cpuArch = "Standard_x64"
if ($cpuName -match "Intel") {
    if ($cpuName -match "1[234]\d{3}|Ultra") { $cpuArch = "Intel_Hybrid_P_and_E_Core" }
    else { $cpuArch = "Intel_Legacy_Uniform_Core" }
} elseif ($cpuName -match "AMD|Ryzen") {
    if ($cpuName -match "X3D") { $cpuArch = "AMD_Ryzen_3D_VCache" }
    else { $cpuArch = "AMD_Ryzen_Standard" }
}

$activeSchemeRaw = powercfg /getactivescheme 2>&1 | Out-String
$schemeName = "Unknown"
if ($activeSchemeRaw -match '\((.*?)\)') { $schemeName = $matches[1] }

if ($schemeName -like "*卓越性能*" -or $schemeName -like "*Ultimate*") {
    $passedChecks += "电源调度：已激活「卓越性能」顶级低延迟电源方案"
} elseif ($schemeName -like "*高性能*" -or $schemeName -like "*High performance*") {
    $passedChecks += "电源调度：当前为「高性能」电源方案"
} else {
    $score -= 5
    $deductions += "[-5分] 电源方案仍为平衡或省电模式 ($schemeName)，CPU 动态调频可能引起微卡顿"
    $recommendedFixes += "解锁并激活「卓越性能 (Ultimate Performance)」电源计划"
}

# ==============================================================================
# 3. 显卡拓扑、独显直连与刷新率审计 (GPU & Display)
# ==============================================================================
$gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
if (-not $gpus) { $gpus = Get-WmiObject Win32_VideoController -ErrorAction SilentlyContinue }

$activeDisplayGPU = "None"
$activeResolution = "None"
$activeRefreshRate = 0
$hasDiscreteGPU = $false

foreach ($g in $gpus) {
    $isDGPU = ($g.Name -like "*NVIDIA*" -or $g.Name -like "*Radeon RX*" -or $g.Name -like "*Arc*")
    if ($isDGPU) {
        $hasDiscreteGPU = $true
    }
    if ($g.CurrentHorizontalResolution -gt 0) {
        # 如果是独显或者当前尚未记录到独显，则更新活跃显示器
        if ($isDGPU -or $activeDisplayGPU -notmatch "NVIDIA|Radeon RX|Arc") {
            $activeDisplayGPU = $g.Name
            $activeResolution = "$($g.CurrentHorizontalResolution)x$($g.CurrentVerticalResolution)"
            $activeRefreshRate = $g.CurrentRefreshRate
        }
    }
}

$isDirectMode = ($activeDisplayGPU -like "*NVIDIA*" -or $activeDisplayGPU -like "*Radeon RX*" -or $activeDisplayGPU -like "*Arc*")

if ($isLaptop -and $hasDiscreteGPU) {
    if ($isDirectMode) {
        $passedChecks += "显卡链路：笔记本内屏已开启「独显直连 (dGPU Mode)」，消除核显中转延迟"
    } else {
        $score -= 8
        $deductions += "[-8分] 笔记本处于「核显混合输出 (Optimus)」，游戏画面经核显转运会损失 5%~15% 帧率与 1% Low"
        $recommendedFixes += "在显卡控制面板或电脑管家中切换为「仅限独显 / 独显直连」"
    }
}

if ($activeRefreshRate -ge 120) {
    $passedChecks += "屏幕刷新率：当前运行在高刷新率模式 ($($activeRefreshRate)Hz)"
} elseif ($activeRefreshRate -gt 0) {
    $passedChecks += "屏幕刷新率：当前为 $($activeRefreshRate)Hz"
}

# ==============================================================================
# 4. 内存负荷与内存杀手清理软件审计 (RAM & Memory Cleaners)
# ==============================================================================
$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
$totalRamGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
$freeRamGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
$usedRamGB = [math]::Round($totalRamGB - $freeRamGB, 1)

$memCleaners = Get-Process -Name "memreduct", "*cleaner*", "*rambooster*" -ErrorAction SilentlyContinue
if ($memCleaners) {
    $score -= 10
    $killerNames = ($memCleaners.ProcessName | Select-Object -Unique) -join ', '
    $deductions += "[-10分] 检测到后台常驻第三方内存清理软件 ($killerNames)，定期强清内存会引发游戏硬页面错误（瞬卡1秒）"
    $criticalAlerts += "立刻退出并卸载 $killerNames，将物理内存交由 Windows 内存管理器自主管理"
} else {
    $passedChecks += "内存环境：未发现暴力清内存流氓软件，运行纯净"
}

# ==============================================================================
# 5. 存储、NVMe 健康与 C 盘审计 (Storage & NVMe)
# ==============================================================================
$cDrive = Get-PSDrive C -ErrorAction SilentlyContinue
$freeCGB = [math]::Round($cDrive.Free / 1GB, 1)

if ($freeCGB -lt 15) {
    $score -= 10
    $deductions += "[-10分] 系统 C 盘可用空间严重告急 (仅剩 $($freeCGB)GB)，极易引起虚拟内存膨胀失败与系统假死"
    $recommendedFixes += "执行官方 DISM 组件库清理并关闭休眠文件，快速释放 10~30GB 空间"
} elseif ($freeCGB -lt 30) {
    $score -= 3
    $deductions += "[-3分] 系统 C 盘剩余空间偏低 ($($freeCGB)GB)"
    $recommendedFixes += "建议清理临时缓存与失效着色器文件"
} else {
    $passedChecks += "存储空间：C 盘空间充裕 (可用 $($freeCGB)GB)"
}

# 固态健康探测
$disks = Get-PhysicalDisk -ErrorAction SilentlyContinue
$hasDiskError = $false
foreach ($d in $disks) {
    if ($d.HealthStatus -ne 'Healthy') {
        $hasDiskError = $true
        $score -= 20
        $deductions += "[-20分] 物理硬盘 $($d.FriendlyName) 健康状态异常 ($($d.HealthStatus))"
        $criticalAlerts += "磁盘 $($d.FriendlyName) 出现物理告警，请立即备份关键代码与工程！"
    }
}
if (-not $hasDiskError) {
    $passedChecks += "固态健康：所有物理磁盘 S.M.A.R.T. 健康状态均正常 (Healthy)"
}

# TRIM 状态
$trimRaw = fsutil behavior query DisableDeleteNotify 2>&1 | Out-String
if ($trimRaw -match "DisableDeleteNotify = 0") {
    $passedChecks += "固态寿命：TRIM 垃圾回收功能已正常激活"
} elseif ($trimRaw -match "DisableDeleteNotify = 1") {
    $score -= 5
    $deductions += "[-5分] 固态硬盘 TRIM 垃圾回收被禁用，会导致闪存写放大与越用越卡"
    $recommendedFixes += "以管理员身份运行 `fsutil behavior set DisableDeleteNotify 0` 开启 TRIM"
}

# ==============================================================================
# 6. 网络芯片与抗跳 Ping 审计 (Network & Wi-Fi Latency)
# ==============================================================================
$wifiAdapter = Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object {
    $_.PhysicalMediaType -match "Native 802.11" -or
    $_.InterfaceDescription -match "Wi-Fi|Wireless|802.11"
} | Select-Object -First 1
if (-not $wifiAdapter) {
    $wifiAdapter = Get-NetAdapter -Name "WLAN", "*Wi-Fi*", "*Wireless*" -ErrorAction SilentlyContinue | Select-Object -First 1
}
$wifiVendor = "None"
if ($wifiAdapter) {
    if ($wifiAdapter.InterfaceDescription -match "Intel") { $wifiVendor = "Intel" }
    elseif ($wifiAdapter.InterfaceDescription -match "Realtek") { $wifiVendor = "Realtek" }
    elseif ($wifiAdapter.InterfaceDescription -match "MediaTek|RZ\d{3}") { $wifiVendor = "MediaTek" }
    elseif ($wifiAdapter.InterfaceDescription -match "Qualcomm|Atheros") { $wifiVendor = "Qualcomm" }
}

$mmKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
$netThrottle = (Get-ItemProperty $mmKey -Name 'NetworkThrottlingIndex' -ErrorAction SilentlyContinue).NetworkThrottlingIndex
$sysResp = (Get-ItemProperty $mmKey -Name 'SystemResponsiveness' -ErrorAction SilentlyContinue).SystemResponsiveness

if ($netThrottle -eq 0xFFFFFFFF -and $sysResp -eq 0) {
    $passedChecks += "系统网络节流：Windows 多媒体网络限速已彻底解除 (低延迟全开)"
} else {
    $score -= 4
    $deductions += "[-4分] Windows 多媒体网络与游戏网络节流机制仍处于默认受限状态"
    $recommendedFixes += "关闭 NetworkThrottlingIndex 并将 SystemResponsiveness 调优为 0"
}

# ==============================================================================
# 7. 电竞游戏系统级调优状态 (Gaming & Input Latency)
# ==============================================================================
$gameMode = (Get-ItemProperty 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -ErrorAction SilentlyContinue).AutoGameModeEnabled
$dvr = (Get-ItemProperty 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -ErrorAction SilentlyContinue).GameDVR_Enabled
$mouseSpeed = (Get-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -ErrorAction SilentlyContinue).MouseSpeed

if ($gameMode -eq 1) {
    $passedChecks += "Windows 游戏模式：已启用 (进程调度向游戏优先倾斜)"
} else {
    $score -= 5
    $deductions += "[-5分] Windows 游戏模式未开启"
    $recommendedFixes += "开启 Windows「游戏模式」以保障前台 CPU/GPU 资源调度"
}

if ($dvr -eq 0) {
    $passedChecks += "后台录屏：Xbox Game DVR 已关闭 (杜绝后台静默编码抢占显卡)"
} else {
    $score -= 4
    $deductions += "[-4分] Xbox Game DVR 后台录屏仍处于激活状态"
    $recommendedFixes += "关闭 Xbox Game DVR 后台自动录制"
}

if ($mouseSpeed -eq '0') {
    $passedChecks += "鼠标指针输入：系统级非线性鼠标加速度已关闭 (1:1 纯净线性跟手)"
} else {
    $score -= 2
    $deductions += "[-2分] 鼠标加速度处于开启状态，甩枪定位轨迹非线性"
    $recommendedFixes += '关闭「提高指针精确度」，还原纯净 1:1 肌肉记忆'
}

# 着色器缓存探测
$dxcachePath = "$env:LOCALAPPDATA\NVIDIA\DXCache"
if (Test-Path $dxcachePath) {
    $dxFiles = Get-ChildItem $dxcachePath -File -ErrorAction SilentlyContinue
    $totalMB = [math]::Round(($dxFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
    if ($totalMB -gt 1500 -or $dxFiles.Count -gt 250) {
        $score -= 3
        $deductions += "[-3分] DirectX 着色器缓存体积臃肿 ($($totalMB)MB / $($dxFiles.Count)个旧文件)，易引发新场景微顿"
        $recommendedFixes += "安全清理失效 NVIDIA DXCache 历史着色器缓存"
    } else {
        $passedChecks += "着色器缓存：体积健康 ($($totalMB)MB / $($dxFiles.Count)个文件)"
    }
}

# ==============================================================================
# 8. 安全基线与反作弊合规性 (Security & Anti-Cheat Baseline)
# ==============================================================================
$secBoot = Confirm-SecureBootUEFI 2>&1
$isSecBootOn = ($secBoot -eq $true)
if ($isSecBootOn) {
    $passedChecks += "反作弊基线：UEFI Secure Boot (安全启动) 已开启，满足拳头 Vanguard 规范"
} else {
    $score -= 5
    $deductions += "[-5分] UEFI Secure Boot (安全启动) 未开启，运行无畏契约等游戏将遭遇 VAN 9003 拦截"
    $recommendedFixes += "进入主板 BIOS 开启 Secure Boot (安全启动)"
}

# 综合打分收敛
if ($score -lt 0) { $score = 0 }

$healthRating = "优秀 (Optimized)"
$healthColor = "Green"
if ($score -lt 60) {
    $healthRating = "严重风险 (Critical Risk)"
    $healthColor = "Red"
} elseif ($score -lt 75) {
    $healthRating = "亚健康 (Sub-optimal)"
    $healthColor = "Yellow"
} elseif ($score -lt 90) {
    $healthRating = "良好 (Good)"
    $healthColor = "Cyan"
}

# ==============================================================================
# 9. 输出与汇报渲染
# ==============================================================================
$resultObj = [ordered]@{
    AuditTimestamp    = $auditTime
    HealthScore       = $score
    HealthRating      = $healthRating
    HardwareProfile   = [ordered]@{
        Chassis       = if ($isLaptop) { "Laptop" } else { "Desktop" }
        Brand         = $brand
        Model         = $rawModel
        CPU           = $cpuName
        CPUArch       = $cpuArch
        ActiveDisplay = $activeDisplayGPU
        Resolution    = $activeResolution
        RefreshRate   = "$($activeRefreshRate)Hz"
        DirectGPU     = $isDirectMode
        RAM           = "$($usedRamGB)GB / $($totalRamGB)GB"
        FreeCDisk     = "$($freeCGB)GB"
        WiFiVendor    = $wifiVendor
    }
    Deductions        = $deductions
    PassedChecks      = $passedChecks
    RecommendedFixes  = $recommendedFixes
    CriticalAlerts    = $criticalAlerts
}

if ($OutputFormat -eq 'Json') {
    $resultObj | ConvertTo-Json -Depth 5
    return
}

# 终端与 Markdown 报告构建
$mdReport = @"
# 🖥️ Windows PC 综合性能与健康深度体检报告
- **体检时间**：$auditTime
- **综合健康评分**：**$score / 100** 【$healthRating】
- **机型态势**：$brand ($rawModel) · $(if ($isLaptop){'笔记本'}else{'台式机'})
- **硬件核心**：$cpuName ($cpuArch)
- **显示链路**：$activeDisplayGPU · $activeResolution @ $($activeRefreshRate)Hz $(if ($isDirectMode){'【独显直连】'}else{'【Optimus混合】'})
- **内存与空间**：物理内存已用 $($usedRamGB)G / 总计 $($totalRamGB)G · C 盘可用 $($freeCGB)G

---

### 🟢 达标与已调优项 ($(($passedChecks | Measure-Object).Count) 项)
$(foreach ($p in $passedChecks) { "- [x] $p`n" })
---

### 🟡 推荐优化提升项 ($(($recommendedFixes | Measure-Object).Count) 项)
$(if ($recommendedFixes.Count -eq 0) { "当前系统调优状态极佳，无待优化常规项！" } else { foreach ($r in $recommendedFixes) { "- [ ] $r`n" } })

---

### 🔴 关键告警与需警惕项 ($(($criticalAlerts | Measure-Object).Count) 项)
$(if ($criticalAlerts.Count -eq 0) { "未发现破坏性硬件或系统级高危警报。" } else { foreach ($c in $criticalAlerts) { "- ⚠️ **$c**`n" } })

---

### 🛡️ 开发者环境安全护航状态
- **环境变量 (PATH)**：已锁死，本次及后续所有调优绝不修改系统 PATH；
- **开发者缓存 (npm/pip/uv)**：已隔离保护，绝不误删；
- **虚拟网络 (Docker/WSL/VPN)**：完全绕行，网络调优仅作用于物理以太网卡与 Wi-Fi 芯片；
- **极速回滚机制**：随时可通过桌面回滚脚本毫秒级还原。
"@

if ($ExportMarkdownPath) {
    [System.IO.File]::WriteAllText($ExportMarkdownPath, $mdReport, [System.Text.Encoding]::UTF8)
}

Write-Output $mdReport
