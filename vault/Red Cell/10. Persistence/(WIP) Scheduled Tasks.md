
>[!info]
>This note is still in development.

### Overview
---
Scheduled Tasks are automated processes or scripts that run at specified intervals or at predetermined times.  
### Example(s) with PowerShell:
---

- **BASIC**: Create a scheduled task that runs as SYSTEM at 9:00am every day.

```powershell

```

- **ADVANCED**: Create a scheduled task that runs a PowerShell command as SYSTEM 3 seconds after the command is executed, then promptly deletes itself after execution.

```powershell
# Create a Scheduled Task to run as an elevated user, then permanently remove itself.
$PS = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command <command>"
$Time = New-ScheduledTaskTrigger -At (Get-Date).AddSeconds(3) -Once
$Time.EndBoundary = (Get-Date).AddSeconds(6).ToString('s')
$Remove = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:00:01

Register-ScheduledTask -TaskName 'Executed Command' -Action $PS -Trigger $Time -Settings $Remove -User SYSTEM -Force
```

### Example(s) with Cmd:
---

Create a scheduled task that runs as SYSTEM at 9:00am every day.
- Requires elevated privileges.

```cmd
SCHTASKS /CREATE /SC DAILY /TN "Microsoft\Windows\ComManager" /TR "<command_to_execute>" /ST 09:00 /RU SYSTEM
```