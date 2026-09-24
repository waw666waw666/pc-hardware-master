# probe-hardware-profile.ps1
# 只读硬件画像与显示底座嗅探工具 (Read-Only Hardware & Display Profiler)

[CmdletBinding()]
param()

$ErrorActionPreference = 'SilentlyContinue'

$profile = [ordered]@{}

# 1. 机器型号与主板品牌
$comp = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
if (-not $comp) { $comp = Get-WmiObject Win32_ComputerSystem -ErrorAction SilentlyContinue }
$profile.Machine = [ordered]@{
    Manufacturer = if ($comp) { $comp.Manufacturer } else { "Unknown" }
    Model        = if ($comp) { $comp.Model } else { "Unknown" }
    SystemType   = if ($comp) { $comp.SystemType } else { "Unknown" }
}

# 2. CPU 处理器架构与核心数
$cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $cpu) { $cpu = Get-WmiObject Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1 }
$profile.CPU = [ordered]@{
    Name             = if ($cpu) { $cpu.Name.Trim() } else { "Unknown CPU" }
    Cores            = if ($cpu) { $cpu.NumberOfCores } else { 0 }
    LogicalThreads   = if ($cpu) { $cpu.NumberOfLogicalProcessors } else { 0 }
    MaxClockSpeedMHz = if ($cpu) { $cpu.MaxClockSpeed } else { 0 }
}

# 3. 物理内存与通道状态
$mem = Get-CimInstance Win32_PhysicalMemory -ErrorAction SilentlyContinue
if (-not $mem) { $mem = Get-WmiObject Win32_PhysicalMemory -ErrorAction SilentlyContinue }
$totalGB = if ($mem) { [math]::Round(($mem | Measure-Object -Property Capacity -Sum).Sum / 1GB, 1) } else { 0 }
$profile.Memory = [ordered]@{
    TotalCapacityGB = $totalGB
    StickCount      = if ($mem) { ($mem | Measure-Object).Count } else { 0 }
    SpeedsMHz       = if ($mem) { ($mem | Select-Object -ExpandProperty ConfiguredClockSpeed -Unique) } else { @() }
}

# 4. 显卡与显示输出挂载 (判断核显输出 vs 独显直连)
$gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
if (-not $gpus) { $gpus = Get-WmiObject Win32_VideoController -ErrorAction SilentlyContinue }
$gpuList = @()
$isdGPUDirect = $false

foreach ($g in $gpus) {
    $hasDisplay = ($g.CurrentHorizontalResolution -gt 0)
    if ($g.Name -like '*NVIDIA*' -and $hasDisplay) {
        $isdGPUDirect = $true
    }
    $gpuList += [ordered]@{
        Name            = $g.Name
        DriverVersion   = $g.DriverVersion
        Resolution      = if ($hasDisplay) { "$($g.CurrentHorizontalResolution)x$($g.CurrentVerticalResolution)" } else { "None (Inactive / Passthrough)" }
        RefreshRateHz   = if ($hasDisplay) { $g.CurrentRefreshRate } else { 0 }
        IsDisplayMaster = $hasDisplay
    }
}
$profile.GPUs = $gpuList
$profile.DisplayTopology = [ordered]@{
    IsDiscreteGPUDirect = $isdGPUDirect
    ModeDescription     = if ($isdGPUDirect) { "独显直连 (Discrete GPU Only / MUX Enabled)" } else { "核显混合输出 (Optimus / Hybrid Mode - 存在跨总线延迟)" }
}

# 5. 当前电源状态与激活方案
$activeScheme = powercfg /getactivescheme 2>&1 | Out-String
$schemeName = "Unknown"
if ($activeScheme -match '\((.*?)\)') { $schemeName = $matches[1] }
$battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
$profile.Power = [ordered]@{
    ActiveScheme    = $schemeName
    IsOnACPower     = ($battery -eq $null) -or ($battery.BatteryStatus -ne 1)
    BatteryCapacity = if ($battery) { "$($battery.EstimatedChargeRemaining)%" } else { "AC Desktop / No Battery" }
}

$profile | ConvertTo-Json -Depth 4
