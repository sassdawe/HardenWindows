<#
    PowerShell Unit Test file
    You'll need a test framework like Pester to execute the tests

    Tests for *function-Show-DefenderAsrRules.ps1*
#>

$ModuleName = "DefenderASR"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
Get-Module $ModuleName | Remove-Module -force
Import-Module $ModuleManifestPath

InModuleScope -ModuleName $ModuleName -ScriptBlock {
    $scripPath = [System.IO.Path]::GetDirectoryName($PSCommandPath).Replace("\Tests","\Lib");
    $testFileName = $PSCommandPath | Split-Path -Leaf;
    $targetFileName = $testFileName.Replace(".tests.",".");
    $function = $targetFileName.Replace("function-","").Replace(".ps1","");

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
    Describe -Name "Functional tests of $function" -Fixture {
        Context -Name "General tests" -Fixture {
            It -Name "$function returns something" {
                Show-DefenderAsrRules | Should -Not -BeNullOrEmpty
                Show-DefenderAsrRules | Should -HaveCount 15
                Show-DefenderAsrRules | Should -BeOfType [PSCustomObject]
            }
        }
    }
}