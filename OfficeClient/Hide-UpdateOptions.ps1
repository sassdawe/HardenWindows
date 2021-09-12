#Requires -RunAsAdministrator

# Enable 'Hide Option to Enable or Disable Updates'
# Controls whether to hide the user interface (UI) options to enable or disable Office automatic updates from users.

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate\"

$Name = "hideenabledisableupdates"

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
    New-Item -Path $registryPath -ItemType Directory -Force | Out-Null
    if (-not (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue) ){
        New-ItemProperty -Path $registryPath -Name $Name -PropertyType DWORD -Value $value -Verbose
    }
}
