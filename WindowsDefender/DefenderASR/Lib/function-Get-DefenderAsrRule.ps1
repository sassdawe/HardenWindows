function Get-DefenderAsrRule {
    <#
        .SYNOPSIS
            Get-DefenderAsrRules
        .DESCRIPTION
            Get-DefenderAsrRules will list all currently existing Attack Surface Reduction rules from the active configuration
        .OUTPUTS
            [PSCustomObject[]]
        .EXAMPLE
            PS > Get-DefenderAsrRules
        .EXAMPLE
        .LINK
            https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-exploit-guard/attack-surface-reduction-exploit-guard
    #>
    [CmdletBinding()]
    param (

    )

    begin {
        Write-Verbose "Get-MpPreference"
        $pref = Get-MpPreference
    }

    process {
        $i = 0
        Write-Verbose "We've $($pref.AttackSurfaceReductionRules_Ids.Count) configured"
        $pref.AttackSurfaceReductionRules_Ids | ForEach-Object {
            Write-Verbose "ASRGuid: $_"
            $g = $_
            $rules[$($g.ToLower())] | ForEach-Object {
                Write-Verbose "ASRName: $($_)"
                $o = $_.PSObject.Copy()
                Write-Verbose $_.Name
                Add-Member -InputObject $o -Name "Action" -MemberType NoteProperty -Value $($states["$($pref.AttackSurfaceReductionRules_Actions[$i])"].Name)
                $o
            }
            $i++
        } | Sort-Object $Id | Select-Object Name, Action, Guid
    }

    end {
    }
}