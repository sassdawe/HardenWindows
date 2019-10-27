# Windows Operating System

## Enable 'Local Security Authority (LSA) protection'

### Description

Forces LSA to run as Protected Process Light (PPL).

### Potential risk

If LSA isn't running as a protected process, attackers could easily abuse the low process integrity for attacks (such as Pass-the-Hash).

`HKLM\SYSTEM\CurrentControlSet\Control\Lsa\RunAsPPL`
`REG_DWORD 1`

## Set User Account Control (UAC) to automatically deny elevation requests

### Description

Determines the behavior of the elevation prompt for standard users.

### Potential risk

Denying elevation requests from standard user accounts requires tasks that need elevation to be initiated by accounts with administrative privileges. This prevents privileged account credentials from being cached with standard user profile information to help mitigate credential theft.

### Remediation optionss

**Option 1** - Set the following registry value:
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorUser

To the following REG_DWORD value: 0

**Option 2** - Set the following Group Policy:
Computer Configuration\Policies\Windows Settings\Security Settings\Local Policies\Security Options\User Account Control\Behavior of the elevation prompt for standard users

To the following value: Automatically deny elevation requests

## Do not execute any autorun commands

### Description

Determines whether Autorun commands are allowed to execute. Autorun commands are generally stored in autorun.inf files. They often launch the installation program or other routines.

### Potential risk

Allowing autorun commands to execute may introduce malicious code to a system without user intervention or awareness. Configuring this setting prevents autorun commands from executing.

### Remediation options

**Option 1** - Set the following registry value:
`HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutorun`

To the following REG_DWORD value: 1

**Option 2** - Set the following Group Policy:
`Computer Configuration\Policies\Administrative Templates\Windows Components\AutoPlay Policies\Set the default behavior for AutoRun`

To the following value: *Enabled\Do not execute any autorun commands*
