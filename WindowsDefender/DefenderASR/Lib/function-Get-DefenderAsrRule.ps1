function Get-DefenderAsrRule {
    <#
        .SYNOPSIS
            Get-DefenderAsrRules
        .DESCRIPTION
            Get-DefenderAsrRules will list all currently existing Attack Surface Reduction rules from the active configuration
        .OUTPUTS
            [PSCustomObject[]]
        .EXAMPLE
            Get-DefenderAsrRules

            Will give you back the current configuration
        .Notes
            Will give back a PSCustomObject will nice human readable rule names and IDs
        .LINK
            https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-exploit-guard/attack-surface-reduction-exploit-guard
    #>
    [CmdletBinding()]
    [Alias('Get-DefenderAsrSetting')]
    param (

    )

    begin {
        Write-Verbose "Get-MpPreference"
        $pref = Get-MpPreference
    }

    process {
        try {
            $i = 0
            Write-Verbose "We've $($pref.AttackSurfaceReductionRules_Ids.Count) configured"
            if ($pref.AttackSurfaceReductionRules_Ids.Count -gt 0) {
                $pref.AttackSurfaceReductionRules_Ids | ForEach-Object {
                    Write-Verbose "ASRGuid: $_"
                    $g = $_
                    $rules[$($g.ToLower())] | ForEach-Object {
                        Write-Verbose "ASRName: $($_)"
                        $o = $_.PSObject.Copy()
                        Write-Verbose $_.Name
                        Add-Member -InputObject $o -Name "Action" -MemberType NoteProperty -Value $($states["$($pref.AttackSurfaceReductionRules_Actions[$i])"].Name)
                        Write-Verbose -Message "`$ActionID = $($pref.AttackSurfaceReductionRules_Actions[$i])"
                        Add-Member -InputObject $o -Name "ActionId" -MemberType NoteProperty -Value $pref.AttackSurfaceReductionRules_Actions[$i]
                        $o
                    }
                    $i++
                    # TODO: keep in mind that extending the returned properties, you have to extend the Select-Object as well
                } | Sort-Object $Id | Select-Object Name, Action, ActionId, Guid
            }
            else {
                Write-Warning "You don't have any ASR rules defined, we recommend to configure some!"
            }
        }
        catch {
            Write-Host "Something went terribly wrong: $_" -ForegroundColor Yellow
        }
    }

    end {
    }
}