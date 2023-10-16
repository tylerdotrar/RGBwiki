
>[!info]
>This note is still in development.

### (WIP) Install GHOSTS
---
Github Link:
- https://github.com/cmu-sei/GHOSTS

### Auto-Logon Random User Accounts
---

```powershell
function Enable-UserEmulation {
#.SYNOPSIS
# Simple script to randomly generate and enable auto-logged on users.
# ARBITRARY VERSION NUMBER:  1.0.0
# AUTHOR:  Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# WIP
# - Requires elevated privileges.
# - Requires .NET 4.6.1 Runtime or later (https://dotnet.microsoft.com/download/dotnet-framework/net47)
#
# Parameters:
#    -Manual         -->   Prompt for user information instead of random generation
#    -Username       -->   Input username without prompt
#    -Password       -->   Input password without prompt (warning: plaintext)
#    -DisplayName    -->   Input display name without prompt (e.g., full name)
#    -Cleanup        -->   Remove all script files once user emulation is setup
#    -Restart        -->   Restart computer immediately upon script completion
#    -Help           -->   Return Get-Help information
#
#.LINK
# https://github.com/tylerdotrar/<TBD>

    Param(
        [switch]$Manual,
        [string]$Username,
        [string]$Password,
        [string]$DisplayName,
        [switch]$Cleanup,
        [switch]$Restart,
        [switch]$Help
    )


    # Return Get-Help information
    if ($Help) { return (Get-Help Enable-UserEmulation) }


    # Verify current user has elevated privileges
    $User    = [Security.Principal.WindowsIdentity]::GetCurrent();
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal $User).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if (!$isAdmin) { return (Write-Host 'This function requires elevated privileges.' -ForegroundColor Red) }


    # Error correction if fake_user.exe is missing
    $Fake_Users = "$LibDir\fake_user.exe"


    # Manually Input User Data
    if ($Manual) {
        if (!$Username) { Write-Host 'Enter Username: ' -ForegroundColor Yellow -NoNewline ; $Username = Read-Host }
        if (!$Password) { Write-Host 'Enter Password: ' -ForegroundColor Yellow -NoNewline ; $Password = Read-Host }
        if (!$DisplayName) { Write-Host 'Enter Display Name: ' -ForegroundColor Yellow -NoNewline ; $DisplayName = Read-Host }
    }


    # Randomly Generate User Data
    else {
        if (!(Test-Path -LiteralPath $Fake_Users)) { return (Write-Host "ERROR: Missing 'fake_user.exe'" -ForegroundColor Red) }
        $UserCSV = (. $Fake_Users -n 1 | ConvertFrom-Csv)

        $FirstName     = $UserCSV.first_name
        $LastName      = $UserCSV.last_name
        $MI            = ($UserCSV.middle_initial).ToUpper()
        $Password      = $UserCSV.password

        $Username      = "$FirstName.$MI.$LastName"
        $DisplayName   = "$FirstName $LastName"
    }


    # Add local unprivileged user and set them to auto-logon
    net user "$Username" "$Password" /FULLNAME:"$DisplayName" /ADD


    # Hash Values for setting registry key
    $Hash=@{
        DefaultUserName="$Username" ;
        DefaultPassword="$Password" ; 
        DefaultDomainName="$Domain" ; # Not sure if I need this or not
        AutoAdminLogon='1'
    }

    foreach ($Key in $Hash.Keys) {
        Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name $Key -Value $($Hash.$Key)
    }


    # Remove all script files once user emulation is setup
    if ($Cleanup) {
        # WIP
    }


    # Restart Computer to auto-logon as new user
    if ($Restart) {
        Write-Host "Restarting computer to begin user emulation..." -ForegroundColor Yellow
        Restart-Computer -Force
    }
}
```