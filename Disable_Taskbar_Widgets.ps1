# -- 1. Disable Taskbar Widgets --
$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
New-ItemProperty -Path $RegistryPath -Name "TaskbarDa" -Value 0 -PropertyType DWord -Force | Out-Null

# -- 5. Refresh Windows Explorer --
Write-Host "Refreshing UI..." -ForegroundColor Green
Stop-Process -Name explorer -Force
