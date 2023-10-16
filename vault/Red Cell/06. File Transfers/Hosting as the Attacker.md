
### Python HTTP Web Server
---

- Simplest method to host files, but only supports file downloads.

```shell
# Simple HTTP Web Server on default port 8000 serving the current directory
python -m http.server

# Simple HTTP Web Server on port 80 serving a specified directory
python -m http.server 80 --directory <target_directory>
```


### impacket-smbserver
---

- Simple SMB server that allows for both uploading and downloading files while capturing Net NTLM hashes.

```shell
# SMB share hosting the current directory
impacket-smbserver <share_name> -smb2support .

# SMB share hosting a specified directory
impacket-smbserver <share_name> -smb2support <target_directory>
```


### PoorMansArmory
---

- Custom Flask-based Python server that provides support for file downloads AND uploads, as well as support for encrypted communication over HTTPS using self-signed certificates.
	- Note: usage of HTTPS is more advanced and requires a self-signed certificate check bypass.
- Link: https://github.com/tylerdotrar/PoorMansArmory

```shell
# PoorMansArmory web server on default port 80 with default directory './uploads'
python ./pma_server.py

# PoorMansArmory web server on custom port with specified directory
python ./pma_server.py --port 8080 --directory /usr/share/windows-binaries

# PoorMansArmory web server using HTTPS on specified port (more advanced)
python ./pma_server.py --port 443 --ssl
```