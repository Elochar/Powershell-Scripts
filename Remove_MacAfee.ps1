# Run this script as Administrator

#Look for any MacAfee Apps
$McAfeeApps = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -match "McAfee" }

#Iterate through the apps and tey to uninstall
if ($McAfeeApps) {
    foreach ($app in $McAfeeApps) {
        Write-Host "Found: $($app.Name). Attempting to uninstall..." -ForegroundColor Cyan
        $app.Uninstall() | Out-Null
    }
    Write-Host "Uninstallation process complete. Please restart your computer." -ForegroundColor Green
} else {
    Write-Host "No McAfee products found via standard CIM query." -ForegroundColor Yellow
}