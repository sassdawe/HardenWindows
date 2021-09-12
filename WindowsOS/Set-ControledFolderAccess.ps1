#Requires -RunAsAdministrator

# Category: Security controls (Exploit Guard)
# Potential risk: Not enabling controlled folder access leaves you exposed to various attack vectors. 
# Audit mode allows you to see audit events in the Microsoft Defender for Endpoint Machine timeline however it does not block suspicious applications. 
# Consider enabling Controlled Folder Access for better protection.
# Remediation: Enable Controlled Folder Access.

[CmdletBinding()]
param (
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="Enable")]
    [Switch]
    $Enable
    ,
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="Audit")]
    [Switch]
    $Audit
    ,
    [Parameter(Mandatory=$true, Position=0, ParameterSetName="Disable")]
    [Switch]
    $Disable
)

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access"

$Name = "EnableControlledFolderAccess"

# values to use
# to disable: 0
# to enable: 1
# to audit: 2
switch ($($PSCmdlet.ParameterSetName)) {
    "Enable" { $value = "1"; break }
    "Audit" { $value = "2"; break }
    "Disable" { $value = "0"; break }
    Default { $value = "2" }
}


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
