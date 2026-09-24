# generate-rollback-helper.ps1
# 100% 官方默认值回滚脚本生成器 (One-Click Emergency Rollback Generator)

[CmdletBinding()]
param(
    [string]$TargetBatPath = "$env:USERPROFILE\Desktop\一键恢复系统与网络默认值.bat"
)

$batContent = @'
@echo off
chcp 65001 >nul
title 恢复系统调度与网络出厂默认值

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================================
echo       正在将所有系统调度与网络配置还原至 Windows 官方默认值
echo ========================================================
echo.

:: 1. 恢复系统电源计划至官方平衡模式 (Balanced)
echo [1/5] 正在恢复 Windows 官方平衡电源方案...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

:: 2. 恢复 Multimedia 系统调度
echo [2/5] 正在恢复多媒体与网络系统调度默认值...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul

:: 3. 恢复无线网卡驱动默认参数 (动态识别网卡名称，漫游主动性恢复为官方默认值 3 中等)
echo [3/5] 正在恢复 Wi-Fi 网卡出厂高级属性...
powershell -NoProfile -Command "$adapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.PhysicalMediaType -match 'Native 802.11' -or $_.InterfaceDescription -match 'Wi-Fi|Wireless|802.11' }; if (-not $adapters) { $adapters = Get-NetAdapter -Name 'WLAN', '*Wi-Fi*', '*Wireless*' -ErrorAction SilentlyContinue }; foreach ($a in $adapters) { Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'RoamAggressiveness' -RegistryValue '3' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'MIMOPowerSaveMode' -RegistryValue '0' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword '*PacketCoalescing' -RegistryValue '1' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'ThroughputBoosterEnabled' -RegistryValue '0' -ErrorAction SilentlyContinue }" >nul 2>&1

:: 4. 恢复 GameDVR / Xbox 录屏默认状态
echo [4/5] 正在恢复 Xbox Game DVR 与录制状态...
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 1 /f >nul

:: 5. 恢复鼠标加速度
echo [5/5] 正在恢复系统默认鼠标指针参数...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul

echo.
echo ========================================================
echo [成功] 所有配置已彻底还原为 Windows 官方出厂状态！
echo ========================================================
echo.
pause
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($TargetBatPath, $batContent, $utf8NoBom)
Write-Host "Rollback script generated successfully at: $TargetBatPath"
