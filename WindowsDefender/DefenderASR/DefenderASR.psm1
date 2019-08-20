Write-Verbose "Clear `$Error to support debugging"
$Global:Error.Clear()

#region Attack surface reduction rules
$script:rules = New-Object System.Collections.Specialized.OrderedDictionary
[PSCustomObject]@{
    ID                   = 0;
    Name                 = "Block executable content from email client and webmail";
    GUID                 = "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 1;
    Name                 = "Block all Office applications from creating child processes";
    GUID                 = "D4F940AB-401B-4EFC-AADC-AD5F3C50688A".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 2;
    Name                 = "Block Office applications from creating executable content";
    GUID                 = "3B576869-A4EC-4529-8536-B80A7769E899".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 3;
    Name                 = "Block Office applications from injecting code into other processes";
    GUID                 = "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 4;
    Name                 = "Block JavaScript or VBScript from launching downloaded executable content";
    GUID                 = "D3E037E1-3EB8-44C8-A917-57927947596D".ToLower();
    IsExclusionSupported = $false
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 5;
    Name                 = "Block execution of potentially obfuscated scripts";
    GUID                 = "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 6;
    Name                 = "Block Win32 API calls from Office macro";
    GUID                 = "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 7;
    Name                 = "Block executable files from running unless they meet a prevalence, age, or trusted list criterion";
    GUID                 = "01443614-cd74-433a-b99e-2ecdc07bfc25".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 8;
    Name                 = "Use advanced protection against ransomware";
    GUID                 = "c1db55ab-c21a-4637-bb3f-a12568109d35".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 9;
    Name                 = "Block credential stealing from the Windows local security authority subsystem (lsass.exe)";
    GUID                 = "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 10;
    Name                 = "Block process creations originating from PSExec and WMI commands";
    GUID                 = "d1e49aac-8f56-4280-b9ba-993a6d77406c".ToLower();
    IsExclusionSupported = $false
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 11;
    Name                 = "Block untrusted and unsigned processes that run from USB";
    GUID                 = "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 12;
    Name                 = "Block Office communication application from creating child processes";
    GUID                 = "26190899-1602-49e8-8b27-eb1d0a1ce869".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 13;
    Name                 = "Block Adobe Reader from creating child processes";
    GUID                 = "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c".ToLower();
    IsExclusionSupported = $true
} | ForEach-Object { $rules.Add($_.GUID, $_) }
[PSCustomObject]@{
    ID                   = 14;
    Name                 = "Block persistence through WMI event subscription";
    GUID                 = "e6db77e5-3df2-4cf1-b95a-636979351e5b".ToLower();
    IsExclusionSupported = $false
} | ForEach-Object { $rules.Add($_.GUID, $_) }

#endregion Attack surface reduction rules

#region ASR States
    $script:states = New-Object System.Collections.Specialized.OrderedDictionary
    $states.Add("0",[PSCustomObject]@{"Id" = 0; "Name" = "Disable"})
    $states.Add("1",[PSCustomObject]@{"Id" = 1; "Name" = "Block"})
    $states.Add("2",[PSCustomObject]@{"Id" = 2; "Name" = "Audit"})

    $script:modes = New-Object System.Collections.Specialized.OrderedDictionary
    $modes.Add("Disable",0)
    $modes.Add("Block",1)
    $modes.Add("Audit",2)
#endregion ASR States

$scriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)

. "$scriptPath\Lib\function-Get-DefenderAsrRule.ps1"
. "$scriptPath\Lib\function-Show-DefenderAsrRule.ps1"
. "$scriptPath\Lib\function-Backup-DefenderAsrSetting.ps1"
. "$scriptPath\Lib\function-Restore-DefenderAsrSetting.ps1"


. "$scriptPath\Lib\function-Clear-DefenderAsrSetting.ps1"
. "$scriptPath\Lib\function-Set-DefenderAsrSetting.ps1"

# Export-ModuleMember -Alias "List-DefenderAsrRules"