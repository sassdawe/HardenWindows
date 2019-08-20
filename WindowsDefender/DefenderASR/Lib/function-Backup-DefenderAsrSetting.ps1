function Backup-DefenderAsrSetting {
    <#
        .SYNOPSIS
            Backup-DefenderAsrSetting
        .DESCRIPTION
            Backup-DefenderAsrSetting will backup your current configuration using JSON format in the specified file(s).
        .PARAMETER Path
            The path of the file where the ASR rules should be saved
        .EXAMPLE
            PS > Backup-DefenderAsrSetting -Path c:\temp\asr-settings.json

            Will backup the current ASR settings into c:\temp\asr-settings.json
    #>
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                    Position=0,
                    ParameterSetName="Backup",
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [System.String[]]
        $Path
    )

    begin {
        Write-Verbose "Get-MpPreference"
        $asrSettings = Get-DefenderAsrRule
    }
    
    process {
        try {
            foreach ( $outPath in $Path ) {
                $null = New-Item $outPath -ItemType File -Force
                $asrSettings | ConvertTo-Json | Out-File $outPath -Force
            }
        }
        catch {
            "$_"
        }
    }
    
    end {
    }
}