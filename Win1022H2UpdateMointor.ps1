#run script everyday on windows desktops and laptops
#if the current version up to date
#do nothing 
#otherwise
#update to the current version

$version=[System.Environment]::OSVersion.Version

$release = $version.Build

if ($release -eq "19044") {
    Write-Host "Current Version Acceptable."
    exit
} else {
    Write-Host "Old version, installing upgrade"
    #do the upgrage, see https://community.syncromsp.com/t/script-to-update-windows-to-version-20h2/127
    $dir = 'C:\Windows\packages'
    mkdir $dir
    #create the directory for the windows packpages
    $webClient = New-Object System.Net.WebClient
    #create a web client instance
    $url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
    #go to the download link for the update
    $file = "$($dir)\Win10Upgrade.exe"
    #find the filename of the executable
    $webClient.DownloadFile($url,$file)
    #get the download file from the webclient and download filename
    Start-Process -FilePath $file -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs $dir'
    #start the process to install the file. 
}

