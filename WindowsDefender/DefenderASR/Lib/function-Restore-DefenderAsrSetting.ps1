function Restore-DefenderAsrSetting {
    <#
        .SYNOPSIS
            Restore-DefenderAsrSetting
        .DESCRIPTION
            Restore-DefenderAsrSetting will restore your current configuration from a JSON formatted file.

            Use Restore-DefenderAsrSetting together with Backup-DefenderAsrSetting during the evaluation of the ASR settings.
        .PARAMETER Path
            The path of the file where the ASR rules can be read from
        .EXAMPLE
            PS > Restore-DefenderAsrSetting -Path c:\temp\asr-settings.json

            Will backup the current ASR settings into c:\temp\asr-settings.json
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]
    param (
        # Specifies a path to the file containing the backup.
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "Restore",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to the file locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if (Test-Path $_ -type Leaf) { $true }
                else { throw "File path is missing $_" }
            })]
        [System.String]
        $Path
        ,
        # Shoult we pass through the new config?
        [Parameter(Mandatory = $false)]
        [switch]
        $PassThru
    )

    begin {

    }

    process {
        try {
            If ($PSCmdlet.ShouldProcess("Defender ASR settings from $Path","Restore")) {
                try {
                    $null = $ids = New-Object System.Collections.ArrayList
                    $null = $actions = New-Object System.Collections.ArrayList
                    Get-Content $Path -Raw | ConvertFrom-JSON | ForEach-Object { $_ } |ForEach-Object {
                        Write-Verbose "$($_.Guid)`t$($_.Action)`t$($modes[$_.Action])"

                        $null = $ids.Add($_.Guid)
                        $null = $actions.Add([int]"$($modes[$_.Action])")
                    }
                    Set-MpPreference -AttackSurfaceReductionRules_Ids $($ids.ToArray()) -AttackSurfaceReductionRules_Actions $($actions.ToArray())

                    if ( $PassThru ) {
                        Get-DefenderAsrRule
                    }
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