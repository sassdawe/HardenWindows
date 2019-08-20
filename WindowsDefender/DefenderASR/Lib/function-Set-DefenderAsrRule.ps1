function Set-DefenderAsrRule {
    <#
        .SYNOPSIS
            Set-DefenderAsrRule
        .DESCRIPTION
            Set-DefenderAsrRule will set the specified ASR rules.

            Use Set-DefenderAsrRule if you want to restart configuring your Rules.
        .PARAMETER Rule
        .EXAMPLE
            PS > Set-DefenderAsrRule

            Will Set out your current ASR Rules
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    param (
        # Rule to set
        [Parameter(Mandatory = $true)]
        [System.String[]]
        [ValidateSet()]
        $Rule
    )

    begin {

    }

    process {
        try {
            If ($PSCmdlet.ShouldProcess("Defender ASR Rules","Set")) {
                try {
                    #Set-MpPreference -AttackSurfaceReductionRules_Ids $null -AttackSurfaceReductionRules_Actions $null
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