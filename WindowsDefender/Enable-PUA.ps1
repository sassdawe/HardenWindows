#Requires -RunAsAdministrator

# Shields up on potentially unwanted applications in your enterprise 
# link 1: https://www.microsoft.com/security/blog/2015/11/25/shields-up-on-potentially-unwanted-applications-in-your-enterprise/
# link 2: https://devblogs.microsoft.com/scripting/update-or-add-registry-key-value-with-powershell/

$registryPath = "HKLM:\Software\Policies\Microsoft\Windows Defender\MpEngine"

$Name = "MpEnablePusX"

# values to use
# to disable: 0
# to enable: 1
# to audit: 2

$value = "1"

if ( ( Test-Path $registryPath )) {
    if (-not (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue) ){
        New-ItemProperty -Path $registryPath -Name $Name -PropertyType DWORD -Value $value
    }
    elseif ($value -ne ((Get-ItemProperty -Path $registryPath -Name $name)."$name") ) {
        Set-ItemProperty -Path $registryPath -Name $Name -Value $value
    }
    else {
        Write-Host "No change was necessary" -ForegroundColor Green
    }
}
