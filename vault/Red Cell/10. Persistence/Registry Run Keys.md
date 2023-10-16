
### Overview
---
The Windows registry contains a '*Run*' key in both HKCU and HKLM that executes every time a user logs in.  Alternatively, there's also a '*RunOnce*' key that executes a single time before deleting itself. 

>[!info]
>HKCU doesn't require elevated privileges, but only works on that specific user.
>HKLM requires elevated privileges, but works on every user.

**Key Paths:**
```powershell
# Executes every time the current user logs on
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce

# Executes every time any user logs on (requires elevated privileges)
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
```

### Example(s) with PowerShell:
---

```powershell
# Set a Run Key to execute every time the current user logs on
$RunPath = 'Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
# Set a Run key to execute every time any user logs on (requires elevated privileges)
$RunPath = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'

$KeyName = "<name>"
$Command = "<command_to_execute>"

Set-ItemProperty -Path $RunPath -Name $KeyName -Value $Command
```


### Example(s) with CMD:
---

```cmd
# Set a Run Key to execute every time the current user logs on
REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v <key_name> /t REG_SZ /d <command_to_execute>

# Set a Run key to execute every time any user logs on
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v <key_name> /t REG_SZ /d <command_to_execute>
```
