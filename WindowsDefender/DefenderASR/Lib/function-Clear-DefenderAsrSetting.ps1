function Clear-DefenderAsrSetting {
    <#
        .SYNOPSIS
            Clear-DefenderAsrSetting
        .DESCRIPTION
            Clear-DefenderAsrSetting will disable all your current ASR rules.

            Use Clear-DefenderAsrSetting if you want to restart configuring your settings.
        .EXAMPLE
            PS > Clear-DefenderAsrSetting

            Will clear out your current ASR settings
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    param (
    )

    begin {

    }

    process {
        try {
            If ($PSCmdlet.ShouldProcess("Defender ASR settings","Clear")) {
                try {
                    Set-MpPreference -AttackSurfaceReductionRules_Ids $null -AttackSurfaceReductionRules_Actions $null
                }
                catch {
                    "$_"
                }
            }
        }
        catch {
            "$_"
        }
    }

    end {
    }
}