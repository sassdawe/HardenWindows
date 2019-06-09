function Show-DefenderAsrRules {
    <#
        .SYNOPSIS
            Show-DefenderAsrRules
        .DESCRIPTION
            Show-DefenderAsrRules will list all available Attack Surface Reduction rules which
            can be used on the system protected by Microsoft Defender ATP
        .PARAMETER
        .PARAMETER
        .INPUTS
        .OUTPUTS
            [PSCustomObject[]]
        .EXAMPLE
            PS > Show-DefenderAsrRules
        .EXAMPLE
        .LINK
    #>
    [CmdletBinding()]
    [Alias("List-DAsrRules")]
    param (
        
    )
    
    begin {
    }
    
    process {
        $rules.Values
    }
    
    end {
    }
}