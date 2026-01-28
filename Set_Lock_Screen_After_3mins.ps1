#This script will change the settings on Windows 11 Machines to Lock the screen after 3 Minutes whether pluged in or not
#This will not lock a user out if they are in a meeting because powercfg /requests sends commands to idle timer to stop while in meeting

#Set lockout timer to 3 minutes
$Timeout = 180

#Ask which bower plan is running
$ActivePlan = $(powercfg /getactivescheme).split(' ')[3]

#Sets lockout timer when system is plugged in
powercfg /setacvalueindex $ActivePlan SUB_VIDEO VIDEOIDLE $Timeout

#Set lockout timer when system is on battery
powercfg /setacvalueindex $ACtivePlan SUB_VIDEO VIDEOIDLE $Timeout

#Apply changes
powercfg /setactive $ActivePlan

Write-Host "Device will now lock screen after 3 minutes" -ForegroundColor Green
  