#Requires -RunAsAdministrator

# Autoplay starts to read from a drive as soon as you insert media in the drive, which causes the setup file for programs or audio media to start immediately
# link 1: https://docs.microsoft.com/en-us/windows-hardware/drivers/install/registering-a-device-specific-co-installer
# link 2: https://twitter.com/wdormann/status/1432703702079508480

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer"

$Name = "DisableCoInstallers"

# values to use
# to disable: 0
# to enable: 1

$value = "1"

if ( ( Test-Path $registryPath -Verbose )) {
    Write-Host "We have the folder"
    if (-not (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue) ){
        New-ItemProperty -Path $registryPath -Name $Name -PropertyType DWORD -Value $value -Verbose
    }
    elseif ($value -ne ((Get-ItemProperty -Path $registryPath -Name $name)."$name") ) {
        Set-ItemProperty -Path $registryPath -Name $Name -Value $value -Verbose
    }
    else {
        Write-Host "No change was necessary" -ForegroundColor Green
    }
}
else {
    Write-Host "We don't have the folder"
    New-Item -Path $registryPath -ItemType Directory
    if (-not (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue) ){
        New-ItemProperty -Path $registryPath -Name $Name -PropertyType DWORD -Value $value -Verbose
    }
}
