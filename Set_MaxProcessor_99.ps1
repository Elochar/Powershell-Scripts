# 1. Define the Hardware GUIDs
$SubGroup_GUID = "54533251-82be-4824-96c1-47b60b740d00" # Processor management
$Setting_GUID  = "bc5038f7-23e0-4960-96da-33abaf5935ec" # Max state

# 2. Get the Active Power Plan GUID
# We use regex to extract ONLY the 36-character GUID string
$ActivePlanInfo = powercfg /getactivescheme
$ActivePlanGUID = ([regex]::Match($ActivePlanInfo, "([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})")).Value

if (-not $ActivePlanGUID) {
    Write-Error "Could not find an active Power Plan GUID."
    return
}

Write-Host "Active Plan Found: $ActivePlanGUID" -ForegroundColor Cyan

# 3. Apply the 99% limit
Write-Host "Applying 99% limit..." -ForegroundColor Yellow

# We wrap variables in quotes to ensure they are passed as clean strings
powercfg /setacvalueindex "$ActivePlanGUID" "$SubGroup_GUID" "$Setting_GUID" 99
powercfg /setdcvalueindex "$ActivePlanGUID" "$SubGroup_GUID" "$Setting_GUID" 99

# 4. Make the change active
powercfg /setactive "$ActivePlanGUID"

Write-Host "Your CPU is now capped at 99%." -ForegroundColor Green