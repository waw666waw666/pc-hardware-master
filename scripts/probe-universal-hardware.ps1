# probe-universal-hardware.ps1
# Universal Hardware Fingerprint and System Stutter Probe

[CmdletBinding()]
param()

$ErrorActionPreference = 'SilentlyContinue'

$report = [ordered]@{}

# 1. Form Factor & Brand Fingerprint
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

# Normalize brand
$brandCategory = "Custom_DIY_Desktop"
if ($rawMfr -match "Lenovo|ThinkPad|IdeaPad") { $brandCategory = "Lenovo" }
elseif ($rawMfr -match "Dell|Alienware") { $brandCategory = "Dell" }
elseif ($rawMfr -match "ASUSTeK|ASUS|ROG|TUF") { $brandCategory = "ASUS" }
elseif ($rawMfr -match "HP|Hewlett-Packard|OMEN|Victus") { $brandCategory = "HP" }
elseif ($rawMfr -match "Micro-Star|MSI") { $brandCategory = "MSI" }
elseif ($rawMfr -match "Acer|Predator|Nitro") { $brandCategory = "Acer" }
elseif ($rawMfr -match "MECHREVO") { $brandCategory = "MECHREVO" }
elseif ($rawMfr -match "Colorful") { $brandCategory = "Colorful" }

$report.FormFactor = [ordered]@{
    IsLaptop           = [bool]$isLaptop
    ChassisType        = if ($isLaptop) { "Laptop" } else { "Desktop" }
    VendorBrand        = $brandCategory
    RawManufacturer    = $rawMfr
    RawModel           = $rawModel
}

# 2. CPU Architecture Taxonomy
$cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $cpu) { $cpu = Get-WmiObject Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1 }
$cpuName = if ($cpu) { $cpu.Name.Trim() } else { "Unknown CPU" }

$cpuArch = "Standard_x64"
if ($cpuName -match "Intel") {
    if ($cpuName -match "1[234]\d{3}|Ultra") {
        $cpuArch = "Intel_Hybrid_P_and_E_Core"
    } else {
        $cpuArch = "Intel_Legacy_Uniform_Core"
    }
} elseif ($cpuName -match "AMD|Ryzen") {
    if ($cpuName -match "X3D") {
        $cpuArch = "AMD_Ryzen_3D_VCache"
    } else {
        $cpuArch = "AMD_Ryzen_Standard"
    }
}

$report.CPU = [ordered]@{
    Name             = $cpuName
    ArchitectureType = $cpuArch
    PhysicalCores    = if ($cpu) { $cpu.NumberOfCores } else { 0 }
    LogicalThreads   = if ($cpu) { $cpu.NumberOfLogicalProcessors } else { 0 }
}

# 3. Multi-GPU and Display Topology
$gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
if (-not $gpus) { $gpus = Get-WmiObject Win32_VideoController -ErrorAction SilentlyContinue }

$gpuDetails = @()
$hasNVIDIA = $false
$hasAMD = $false
$hasIntelArc = $false
$activeDisplayGPU = "None"
$activeResolution = "None"
$activeRefreshRate = 0

foreach ($g in $gpus) {
    $hasDisplay = ($g.CurrentHorizontalResolution -gt 0)
    if ($g.Name -like "*NVIDIA*") { $hasNVIDIA = $true }
    if ($g.Name -like "*Radeon*" -or $g.Name -like "*AMD*") { $hasAMD = $true }
    if ($g.Name -like "*Intel*Arc*") { $hasIntelArc = $true }

    $isDGPU = ($g.Name -like "*NVIDIA*" -or $g.Name -like "*Radeon RX*" -or $g.Name -like "*Arc*")

    if ($hasDisplay) {
        if ($isDGPU -or $activeDisplayGPU -notmatch "NVIDIA|Radeon RX|Arc") {
            $activeDisplayGPU = $g.Name
            $activeResolution = "$($g.CurrentHorizontalResolution)x$($g.CurrentVerticalResolution)"
            $activeRefreshRate = $g.CurrentRefreshRate
        }
    }

    $gpuDetails += [ordered]@{
        Name            = $g.Name
        DriverVersion   = $g.DriverVersion
        Status          = $g.Status
        IsDrivingScreen = $hasDisplay
        Resolution      = if ($hasDisplay) { "$($g.CurrentHorizontalResolution)x$($g.CurrentVerticalResolution)" } else { "Inactive / Passthrough" }
        RefreshRateHz   = if ($hasDisplay) { $g.CurrentRefreshRate } else { 0 }
    }
}

$muxStatus = "Not_Applicable_Desktop"
if ($isLaptop) {
    if ($activeDisplayGPU -like "*NVIDIA*" -or $activeDisplayGPU -like "*Radeon RX*" -or $activeDisplayGPU -like "*Arc*") {
        $muxStatus = "Discrete_GPU_Direct"
    } else {
        $muxStatus = "Hybrid_Optimus_MSHybrid"
    }
}

$report.Graphics = [ordered]@{
    DisplayMasterGPU     = $activeDisplayGPU
    ActiveResolution     = $activeResolution
    ActiveRefreshRateHz  = $activeRefreshRate
    MUXSwitchStatus      = $muxStatus
    GPUVendorsPresent    = @(if ($hasNVIDIA){"NVIDIA"}; if ($hasAMD){"AMD"}; if ($hasIntelArc){"IntelArc"})
    AllInstalledAdapters = $gpuDetails
}

# 4. Universal Network Card Identification
$netAdapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" }
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

$report.Network = [ordered]@{
    WiFiAdapterName   = if ($wifiAdapter) { $wifiAdapter.Name } else { "No Wi-Fi" }
    WiFiDescription   = if ($wifiAdapter) { $wifiAdapter.InterfaceDescription } else { "N/A" }
    WiFiVendorFamily  = $wifiVendor
    ActiveNICCount    = ($netAdapters | Measure-Object).Count
}

# 5. Universal Latency and System Flags
$gameMode = (Get-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -ErrorAction SilentlyContinue).AutoGameModeEnabled
$dvr = (Get-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -ErrorAction SilentlyContinue).GameDVR_Enabled
$mouseSpeed = (Get-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -ErrorAction SilentlyContinue).MouseSpeed

$activeScheme = powercfg /getactivescheme 2>&1 | Out-String
$schemeName = "Unknown"
if ($activeScheme -match '\((.*?)\)') { $schemeName = $matches[1] }

$memCleaners = Get-Process -Name "memreduct", "*cleaner*", "*rambooster*" -ErrorAction SilentlyContinue

$report.SystemTuneStatus = [ordered]@{
    ActivePowerScheme        = $schemeName
    IsGameModeEnabled        = ($gameMode -eq 1)
    IsGameDVRActive          = ($dvr -eq 1)
    IsMouseAccelActive       = ($mouseSpeed -ne '0' -and $mouseSpeed -ne $null)
    MemoryKillerRunning      = if ($memCleaners) { $memCleaners.ProcessName } else { @() }
}

$report | ConvertTo-Json -Depth 5
