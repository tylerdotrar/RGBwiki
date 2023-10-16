
>[!info]
>Requires elevated privileges to run.


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
