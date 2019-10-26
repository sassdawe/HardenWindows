function New-ErrorRecord {
    <#
        .SYNOPSIS
            New-ErrorRecord
        .DESCRIPTION
            New-ErrorRecord
        .OUTPUTS

        .EXAMPLE
            throw ( New-ShouldErrorRecord -Message $testResult.FailureMessage -File $file -Line $lineNumber -LineText $lineText )
        .EXAMPLE
        .LINK
            https://github.com/pester/Pester/blob/master/Functions/Assertions/Should.ps1
    #>
    param (
        [string]
        $Message
        ,
        [string]
        $File
        ,
        [string]
        $Line
        ,
        [string]
        $LineText
    )
    $exception = & $SafeCommands['New-Object'] Exception $Message
    $errorID = 'PesterAssertionFailed'
    $errorCategory = [Management.Automation.ErrorCategory]::InvalidResult
    # we use ErrorRecord.TargetObject to pass structured information about the error to a reporting system.
    $targetObject = @{Message = $Message; File = $File; Line = $Line; LineText = $LineText}
    $errorRecord = & $SafeCommands['New-Object'] Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
    return $errorRecord
}