
>[!info]
>This note is still in development.

An easy method to establish persistence is via the Startup programs directory.  Binaries (or links) thrown in this directory execute at system startup.

```cmd
# CMD Path
"%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
```

```powershell
# PowerShell Path
"$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
```

![[Pasted image 20230828112507.png]]
