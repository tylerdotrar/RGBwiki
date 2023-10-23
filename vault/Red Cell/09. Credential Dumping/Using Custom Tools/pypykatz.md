
This note does not cover the basics of Windows authentication.  For an overview of local Windows authentication, reference my [Windows Authentication](../Windows%20Authentication.md) note.
## Overview
---
**Pypykatz** is a Python library and toolset designed for interacting with the Windows Security Authority Subsystem Service (LSASS), which can be used for extracting various authentication credentials and secrets, including plaintext passwords and password hashes.

> [!info]
> The pypykatz usage wiki can be found [here](https://github.com/skelsec/pypykatz/wiki).

## Usage
---
#### Installation

- Currently (as of October 2023), the Kali Linux version of ``pypykatz`` is version 0.6.6 which does not support Windows 11 dumps.  To fix this, we need to update to the latest version (>=0.6.8).

```shell
# Manual Pypykatz Installation
pip3 install minidump minikerberos asn1crypto
git clone https://github.com/skelsec/pypykatz
cd pypykatz
sudo python3 setup.py install

# Validate pypykatz version was updated
pypykatz version
```

#### Using with Saved Registry Hives

```shell
# Export hashes stored in exported registry hives to a file
pypykatz registry <system_outfile> --sam <sam_outfile> -o hashes.txt

# Crack hashes via John
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt --format=NT
```

### Using with LSASS Dump

```shell
# Exporting hashes stored in LSASS's process memory to a file
pypykatz lsa minidump <lsass_dump> > hashes.txt
```