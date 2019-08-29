# DefenderASR

## Microsoft Defender Attack Surface Reduction configurator

This modules was created to help manually configure the local ASR settings of a machine in a small scale scenario where doesn't make sense to use System Center Configuration Manager, Microsoft Intune or Group Policies to deploy the settings.

This is not a PowerShell DSC provider, only a simple module which gives you a couple of cmdlets:

- `Get-DefenderAsrRule` to list the currently configured rules
- `Show-DefenderAsrRule` to list the available rules
- `Backup-DefenderAsrSetting` to backup the current configuration into JSON file
- `Clear-DefenderAsrSetting` erase the current settings
- `Set-DefenderAsrSetting` overwrite the current settings
- `Restore-DefenderAsrSetting` restore the settings from the backup

Coming later:

- `Add-DefenderAsrRule` to add one or more new rules to the current settings

### Installation

You can always download the code from here but the module is also published into the [PowerShell Gallery](https://www.powershellgallery.com/packages/DefenderASR/)
