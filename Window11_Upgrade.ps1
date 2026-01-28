#remove limits to ensure PS runs as admin
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

#defind the minimun disk space, upgrade condition, and download link for the .exe file
$minDiskGB = 64
$readyToUpgrade = $true
$downloadPath = "$env:TEMP\Win11InstallationAssistant.exe"
$url = "https://go.microsoft.com/fwlink/?linkid=2171764"

Write-Host "--- Initiating Windows 11 Readiness Check ---" -ForegroundColor Cyan

#Check to see if the user has admin during run
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Script must be run as Administrator."
    return
}

#Check to see if the TPM is the correct version (2.0)
$tpm = Get-Tpm
if (-not $tpm.TpmPresent) {
    Write-Host "[FAIL] TPM 2.0 not detected or enabled." -ForegroundColor Red
    #if TPM is not enable then enable it
    Write-Host "Running commmands to enable TPM settings..." -ForegroundColor DarkGreen
    $interface = Get-WmiObject -Namespace root\wmi -Class Lenovo_SetBiosSetting
    $interface.SetBiosSetting("SecurityChip,Active")
    $save = Get-WmiObject -Namespace root\wmi -Class Lenovo_SaveBiosSettings
    $save.SaveBiosSettings()

} else {
    Write-Host "[PASS] TPM 2.0 is present." -ForegroundColor Green
}

#Check to see if secure boot is enabled (required for upgrade)
$secureBoot = Confirm-SecureBootUEFI
if ($secureBoot -ne $true) {
    Write-Host "[FAIL] Secure Boot is not enabled." -ForegroundColor Red
    $readyToUpgrade = $false
} else {
    Write-Host "[PASS] Secure Boot is enabled." -ForegroundColor Green
}

#Look to see if there is enough disk space
$systemDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeSpaceGB = [math]::Round($systemDrive.FreeSpace / 1GB, 2)

#Check if free space is insufficent
if ($freeSpaceGB -lt $minDiskGB) {
    Write-Host "[FAIL] Insufficient disk space. Have: $freeSpaceGB GB, Need: $minDiskGB GB" -ForegroundColor Red
    $readyToUpgrade = $false
} else {
    Write-Host "[PASS] Sufficient disk space ($freeSpaceGB GB available)." -ForegroundColor Green
}

#If all conditions are met, begin upgrade
if ($readyToUpgrade) {
    Write-Host "[PASS] All system checks cleared." -ForegroundColor Green
    $confirm = Read-Host "Proceed with Windows 11 Download? (Y/N)"
    
    if ($confirm -eq 'Y') {
        Write-Host "Downloading Windows 11 Installer via Curl..." -ForegroundColor Yellow
        
        # Using curl.exe (the -L follows redirects, -o specifies output name)
        curl.exe -L $url -o $downloadPath

        if (Test-Path $downloadPath) {
            Write-Host "Download Complete. Launching Installer Silently..." -ForegroundColor Green
            # Launching the .exe with silent switches
            Start-Process -FilePath $downloadPath -ArgumentList "/QuietInstall /SkipEULA /NoRestartUI" -Wait
        } else {
            Write-Host "[ERROR] Download failed." -ForegroundColor Red
        }
    }
} else {
    Write-Host "Upgrade aborted. Hardware or system requirements not met." -ForegroundColor Red
}