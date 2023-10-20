
This note does not cover the basics of Windows authentication.  For an overview of local Windows authentication, reference my [Windows Authentication](../Windows%20Authentication.md) note.
## Overview
---
**reg.exe** is a command-line utility in Microsoft Windows that allows users to interact with the Windows Registry.  It is often used to perform tasks such as:

- Adding, modifying, or deleting registry keys and values.
- Querying the registry to retrieve information.
- Loading and unloading registry hives.
- Exporting and importing registry data to and from files.

Using the latter tasks' functionality, we can export entire hives to files (e.g., `SYSTEM`, `SAM`, and `SECURITY`), which can then be extracted and cracked offline.

## Usage
---

- When exporting the `SAM` and/or `SECURITY` hive(s), make sure to also export the `SYSTEM` hive.
	- The `SYSTEM` hive provides critical system and configuration information that `pypykatz` (and other tools) rely on to locate and parse the `SAM` hive, which stores user account security data.

```powershell
#Export SYSTEM, SAM, and SECURITY hives to files
reg save HKLM\SYTEM <system_outfile>
reg save HKLM\SAM <sam_outfile>
reg save HKLM\SECURITY <security_outfile>
```

- Next you'll have to have exfil the dump file to your attacker and parse it with with a tool like ``pypykatz``.
	- For lateral movement methods and techniques, reference my [Windows File Transfers](../../06.%20File%20Transfers/Windows%20File%20Transfers.md) note.
	- For *pypykatz* usage, reference my [pypykatz](../Using%20Custom%20Tools/pypykatz.md) note.