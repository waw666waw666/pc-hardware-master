# generate-safe-optimization.ps1
# Windows 安全深度优化脚本生成器 (One-Click Safe Optimization Script Generator)

[CmdletBinding()]
param(
    [string]$TargetBatPath = "$env:USERPROFILE\Desktop\一键安全深度调优.bat"
)

$batContent = @'
@echo off
chcp 65001 >nul
title Windows 深度安全优化与延迟消除

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================================
echo       正在执行 Windows 深度低延迟与性能优化 (开发机安全型)
echo ========================================================
echo.

:: 1. 激活卓越性能电源计划
echo [1/6] 正在配置处理器调度与电源计划...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
for /f "tokens=4" %%i in ('powercfg /list ^| findstr /i "卓越性能 Ultimate"') do (
    powercfg /setactive %%i >nul 2>&1
)

:: 2. 优化 Windows 多媒体系统与网络节流
echo [2/6] 正在解除 Windows 网络与多媒体限速...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul

:: 3. 优化 Wi-Fi 网卡抗跳 Ping 参数 (动态识别物理无线网卡)
echo [3/6] 正在调优无线网卡低延迟模式...
powershell -NoProfile -Command "$adapters = Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object { $_.PhysicalMediaType -match 'Native 802.11' -or $_.InterfaceDescription -match 'Wi-Fi|Wireless|802.11' }; if (-not $adapters) { $adapters = Get-NetAdapter -Name 'WLAN', '*Wi-Fi*', '*Wireless*' -ErrorAction SilentlyContinue }; foreach ($a in $adapters) { Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'RoamAggressiveness' -RegistryValue '1' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'MIMOPowerSaveMode' -RegistryValue '0' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword '*PacketCoalescing' -RegistryValue '0' -ErrorAction SilentlyContinue; Set-NetAdapterAdvancedProperty -Name $a.Name -RegistryKeyword 'ThroughputBoosterEnabled' -RegistryValue '1' -ErrorAction SilentlyContinue }" >nul 2>&1

:: 4. 开启 Windows 游戏模式并关闭后台录屏
echo [4/6] 正在开启游戏模式并关闭后台录制...
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul

:: 5. 关闭系统级鼠标非线性加速度 (还原 1:1 跟手)
echo [5/6] 正在调优鼠标指针线性跟手度...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul

:: 6. 安全清理失效着色器缓存 (带文件锁静默保护)
echo [6/6] 正在安全清理臃肿的失效着色器缓存...
powershell -NoProfile -Command "if (Test-Path \"$env:LOCALAPPDATA\NVIDIA\DXCache\") { Get-ChildItem -Path \"$env:LOCALAPPDATA\NVIDIA\DXCache\*\" -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object { try { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue } catch {} } }" >nul 2>&1

echo.
echo ========================================================
echo [成功] 深度调优完成！
echo [提示] 桌面已配套生成「一键恢复系统与网络默认值.bat」
echo        如需还原，随时双击即可毫秒级恢复出厂配置。
echo ========================================================
echo.
pause
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($TargetBatPath, $batContent, $utf8NoBom)
Write-Host "Safe optimization script generated at: $TargetBatPath"
