$scriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)

function Set-DefenderAsrSetting {
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
        # Option we want to enable
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet("Disable", "Block", "Audit")]
        [System.String[]]
        $Action
    )
    DynamicParam {
        # create a new ParameterAttribute Object
        $ruleAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ruleAttribute.Position = 1
        $ruleAttribute.Mandatory = $true
        $ruleAttribute.HelpMessage = "Specify one or more rules"

        # create an attributecollection object for the attribute we just created.
        $attributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]

        # add our custom attribute
        $attributeCollection.Add($ruleAttribute)

        $attributeCollection.Add((New-Object System.Management.Automation.ValidateSetAttribute((Get-Content -Path "$scriptPath\..\Config\asr-rules.json" -Raw | ConvertFrom-Json | ForEach-Object { $_ } | Select-Object -ExpandProperty Name))))

        # add our paramater specifying the attribute collection
        $ruleParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Rule', [System.String[]], $attributeCollection)

        #expose the name of our parameter
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add('Rule', $ruleParam)
        return $paramDictionary
    }
    begin {
        $rule = $PSBoundParameters.Rule
        Write-Debug "`$Rule.Count: $($Rule.Count)`n`$Action.Count:$($Action.Count)"
        if ( $Rule.Count -ne $Action.Count) {
            Throw "You need to provide the same number of actions and rules."
        }
    }

    process {
        try {
            $null = $ids = New-Object System.Collections.ArrayList
            $null = $actions = New-Object System.Collections.ArrayList
            for ($i = 0; $i -lt $Action.Count; $i++) {

                If ($PSCmdlet.ShouldProcess("$($rule[$i]) as $($action[$i])", "Set")) {
                    try {
                        # "#Set-MpPreference -AttackSurfaceReductionRules_Ids '$($rule[$i])' -AttackSurfaceReductionRules_Actions '$($action[$i])'"
                        $null = $ids.Add( $( $rules.Values | Where-Object { $_.Name -eq $rule[$i] } ).Guid )
                        $null = $actions.Add( [int]"$($modes[$action[$i]])" )
                    }
                    catch {
                        "$_"
                    }
                }
            }
            Write-Verbose $( $ids.ToArray() -join "," )
            Write-Verbose $( $actions.ToArray() -join "," )
            If ($PSCmdlet.ShouldProcess("Existing Defender ASR Settings", "Overwrite")) {
                Set-MpPreference -AttackSurfaceReductionRules_Ids $ids.ToArray() -AttackSurfaceReductionRules_Actions $actions.ToArray()
            }
        }
        catch {
            "$_"
        }
    }

    end {
    }
}