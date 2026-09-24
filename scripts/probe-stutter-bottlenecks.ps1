# probe-stutter-bottlenecks.ps1
# 只读电竞掉帧与系统延迟瓶颈排查工具 (Read-Only Gaming Stutter & Latency Bottleneck Probe)

[CmdletBinding()]
param()

$ErrorActionPreference = 'SilentlyContinue'

$findings = [ordered]@{}

# 1. Windows 游戏模式
$gameMode = (Get-ItemProperty 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -ErrorAction SilentlyContinue).AutoGameModeEnabled
$findings['GameModeEnabled'] = ($gameMode -eq 1)

# 2. Xbox Game DVR 后台录屏
$dvr1 = (Get-ItemProperty 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -ErrorAction SilentlyContinue).GameDVR_Enabled
$dvr2 = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -ErrorAction SilentlyContinue).AppCaptureEnabled
$findings['GameDVR_Active'] = ($dvr1 -eq 1 -or $dvr2 -eq 1)

# 3. 内存清理软件进程检测
$memCleaners = Get-Process -Name 'memreduct', '*cleaner*', '*rambooster*' -ErrorAction SilentlyContinue
$findings['MemoryCleanersRunning'] = if ($memCleaners) { $memCleaners.ProcessName } else { @() }

# 4. 显卡着色器缓存状态
$dxcachePath = "$env:LOCALAPPDATA\NVIDIA\DXCache"
if (Test-Path $dxcachePath) {
    $dxFiles = Get-ChildItem $dxcachePath -File -ErrorAction SilentlyContinue
    $totalMB = [math]::Round(($dxFiles | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
    $findings['DXCache'] = [ordered]@{
        FileCount = $dxFiles.Count
        TotalMB   = $totalMB
        IsBloated = ($totalMB -gt 1000 -or $dxFiles.Count -gt 150)
    }
} else {
    $findings['DXCache'] = [ordered]@{
        FileCount = 0
        TotalMB   = 0
        IsBloated = $false
    }
}

# 5. 系统级鼠标指针加速
$mouseSpeed = (Get-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -ErrorAction SilentlyContinue).MouseSpeed
$findings['MouseAccelerationEnabled'] = ($mouseSpeed -ne '0' -and $mouseSpeed -ne $null)

# 6. 无线网卡关键抗跳 Ping 参数 (动态识别物理 Wi-Fi 网卡)
$wifiAdapter = Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object {
    $_.PhysicalMediaType -match "Native 802.11" -or
    $_.InterfaceDescription -match "Wi-Fi|Wireless|802.11"
} | Select-Object -First 1
if (-not $wifiAdapter) {
    $wifiAdapter = Get-NetAdapter -Name "WLAN", "*Wi-Fi*", "*Wireless*" -ErrorAction SilentlyContinue | Select-Object -First 1
}

if ($wifiAdapter) {
    $wlanProps = Get-NetAdapterAdvancedProperty -Name $wifiAdapter.Name -ErrorAction SilentlyContinue
    if ($wlanProps) {
        $roam = ($wlanProps | Where-Object { $_.RegistryKeyword -eq 'RoamAggressiveness' }).RegistryValue
        $mimo = ($wlanProps | Where-Object { $_.RegistryKeyword -eq 'MIMOPowerSaveMode' }).RegistryValue
        $coalesce = ($wlanProps | Where-Object { $_.RegistryKeyword -eq '*PacketCoalescing' }).RegistryValue
        
        $findings['WiFi_Tuning'] = [ordered]@{
            AdapterName        = $wifiAdapter.Name
            AdapterDescription = $wifiAdapter.InterfaceDescription
            RoamAggressiveness = $roam # 1=Lowest, 2=Medium-Low, 3=Medium (出厂默认), 4=Medium-High, 5=Highest
            MIMOPowerSaveMode  = $mimo # 0=No SMPS, 1=Auto, 2=Dynamic
            PacketCoalescing   = $coalesce # 0=Disabled, 1=Enabled
            HasLatencyRisks    = ($roam -gt 1 -or $mimo -ne 0 -or $coalesce -eq 1)
        }
    } else {
        $findings['WiFi_Tuning'] = "Advanced properties not readable for $($wifiAdapter.Name)"
    }
} else {
    $findings['WiFi_Tuning'] = "Physical Wi-Fi adapter not found"
}

# 7. Windows 多媒体网络与 CPU 节流
$mmKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile'
$netThrottle = (Get-ItemProperty $mmKey -Name 'NetworkThrottlingIndex' -ErrorAction SilentlyContinue).NetworkThrottlingIndex
$sysResp = (Get-ItemProperty $mmKey -Name 'SystemResponsiveness' -ErrorAction SilentlyContinue).SystemResponsiveness
$findings['MultimediaThrottling'] = [ordered]@{
    NetworkThrottlingIndex = $netThrottle
    SystemResponsiveness   = $sysResp
    IsThrottled            = ($netThrottle -ne 0xFFFFFFFF -or $sysResp -ne 0)
}

# 8. 无畏契约本地配置快速检查 (如果存在)
$valConfig = Get-ChildItem -Path "$env:LOCALAPPDATA\VALORANT\Saved\Config" -Filter 'GameUserSettings.ini' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($valConfig) {
    $content = Get-Content $valConfig.FullName -Raw -ErrorAction SilentlyContinue
    $shadowQuality = if ($content -match 'sg\.ShadowQuality=(\d+)') { [int]$matches[1] } else { -1 }
    $fpsLimit = if ($content -match 'FrameRateLimit=([\d\.]+)') { [float]$matches[1] } else { -1 }
    $findings['ValorantSettings'] = [ordered]@{
        ConfigFile    = $valConfig.FullName
        ShadowQuality = $shadowQuality
        FrameRateLimit = $fpsLimit
        HasGraphicsLagRisk = ($shadowQuality -gt 1 -or $fpsLimit -eq 0)
    }
}

$findings | ConvertTo-Json -Depth 4
