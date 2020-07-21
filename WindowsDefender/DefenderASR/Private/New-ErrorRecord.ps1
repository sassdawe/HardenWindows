function New-ErrorRecord {
    <#
        .SYNOPSIS
            New-ErrorRecord
        .DESCRIPTION
            New-ErrorRecord
        .OUTPUTS

        .EXAMPLE
            throw ( New-ErrorRecord -Message $testResult.FailureMessage -File $file -Line $lineNumber -LineText $lineText )
        .EXAMPLE
        .LINK
            https://github.com/pester/Pester/blob/master/Functions/Assertions/Should.ps1
        .NOTES
            Origin: PESTER
            Credit should go to the author of PESTER
    #>
    param (
        [string]
        $Message = "Houston we have a problem"
        ,
        [string]
        $File = "Apollo11.rocket"
        ,
        [string]
        $Line = "Never stop exploring"
        ,
        [string]
        $LineText = "bebi shark"
    )
    $exception = New-Object -TypeName "Exception" -ArgumentList $Message
    $errorID = 'PesterAssertionFailed'
    $errorCategory = [Management.Automation.ErrorCategory]::InvalidResult
    # we use ErrorRecord.TargetObject to pass structured information about the error to a reporting system.
    $targetObject = @{Message = $Message; File = $File; Line = $Line; LineText = $LineText}
    $errorRecord = New-Object -TypeName "Management.Automation.ErrorRecord" $exception, $errorID, $errorCategory, $targetObject
    return $errorRecord
}