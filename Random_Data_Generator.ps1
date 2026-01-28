#This is a powershell script that will generated 20 10mb .txt files and save to a folder
#on my desktop, the only reason I am doing this is to improve my skills with powershell 
#and also so that I can use this as test data to test out a new Version on Unbuntu Server on SFTP server

#Fix the Execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Unblock-File -Path "C:\Users\cole.hartnett\Desktop\Powershell Scripts\Random_Data_Generator.ps1"

#Create the path to my desktop
$desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

#Combine desktop path to name of new file
$folderPath = Join-Path $desktopPath "Generate Random Data"

#Check to see if the folder is already there
if (-not (Test-Path $folderPath)) {
    #create a new folder 
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Created Folder: $folderPath" -ForegroundColor Cyan
}

#create the counts of the files and their max size
$fileCount = 20
$sizeInBytes = 10MB

#begin logic loop
for ($i = 1; $i -le $fileCount; $i++) {
    #create file
    $fileName = "Random_Data_$i.txt"
    #join to the file path
    $filePath = Join-Path $folderPath $fileName

    #create an empty byte array 
    $data = New-Object Byte[] $sizeInBytes

    #fill with random data
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($data)

    #Take the bytes from ram and write to the file
    [System.IO.File]::WriteAllBytes($filePath, $data)

    Write-Host "Created: $FileName" -ForegroundColor Green
}

Write-host "'nDone! Files are ready!"