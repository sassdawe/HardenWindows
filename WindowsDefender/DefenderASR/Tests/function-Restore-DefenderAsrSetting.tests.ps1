<#
    PowerShell Unit Test file
    You'll need a test framework like Pester to execute the tests

    Tests for *function-Backup-DefenderAsrSetting.ps1*
#>

$ModuleName = "DefenderASR"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
Get-Module $ModuleName | Remove-Module -force
Import-Module $ModuleManifestPath

InModuleScope -ModuleName $ModuleName -ScriptBlock {
    $scripPath = [System.IO.Path]::GetDirectoryName($PSCommandPath).Replace("\Tests", "\Lib");
    $testFileName = $PSCommandPath | Split-Path -Leaf;
    $targetFileName = $testFileName.Replace(".tests.", ".");
    $function = $targetFileName.Replace("function-", "").Replace(".ps1", "");

    Describe -Name "Validation tests of $function" -Fixture {
        Context -Name "Validation of file" -Fixture {
            It "$targetFileName contains a Function" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent "function $function"
            }
            It "$targetFileName contains an Advanced Function" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent "CmdletBinding()"
            }
            It "$targetFileName contains a Synopsis" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent ".SYNOPSIS"
            }
            It "$targetFileName is a valid script file" {
                $script = Get-Content "$scripPath\$targetFileName" -ErrorAction Stop
                $errors = $null
                [System.Management.Automation.PSParser]::Tokenize($script, [ref]$errors) | Out-Null
                $errors.Count | Should Be 0
            }
        }
    }
    <#    Describe -Name "Functional tests of $function" -Fixture {
        Context -Name "General tests" -Fixture {
            It -Name "$function returns something" {
                Backup-DefenderAsrSetting -path "TestDrive:\asr-settings-0.json"
                "TestDrive:\asr-settings-0.json" | SHould -Exist
                "TestDrive:\asr-settings-0.json" | SHould -FileContentMatch -ExpectedContent "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84"
                "TestDrive:\asr-settings-0.json" | SHould -FileContentMatch -ExpectedContent "Audit"
            }
        }
    }#>

    Describe -Name "Functional tests of $function with a MOCK" -Fixture {
        Mock -CommandName "Set-MpPreference" -MockWith {
            param (
                [ValidateNotNullOrEmpty()]
                [string[]]
                $AttackSurfaceReductionRules_Ids
                ,
                [ValidateNotNullOrEmpty()]
                [int[]]
                $AttackSurfaceReductionRules_Actions
            )
            try {
                $info = @{ }
                $info."AttackSurfaceReductionRules_Ids" = $AttackSurfaceReductionRules_Ids
                $info."AttackSurfaceReductionRules_Actions" = $AttackSurfaceReductionRules_Actions
                return [PSCustomObject]$info
            }
            catch {
                Write-Warning "$_"
            }
        } -ModuleName DefenderASR

        Context -Name "General tests with a MOCK" -Fixture {
            It -Name "$function returns current config" {
                Backup-DefenderAsrSetting -path "TestDrive:\asr-settings-1.json"
                $mockReturned = Restore-DefenderAsrSetting -path "TestDrive:\asr-settings-1.json" -Confirm:$false -Verbose:$true
                $mockReturned | SHould -Not -BeNullOrEmpty
                $mockReturned | ConvertTo-Json | clip.exe
                $mockReturned.AttackSurfaceReductionRules_Actions.Count | SHould -Be 6
                $mockReturned.AttackSurfaceReductionRules_Ids.Count | SHould -Be 6
            }
        }
    }
}