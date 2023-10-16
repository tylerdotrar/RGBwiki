
### Downloading and Uploading via Common Web Tools
---
**CURL**
- Supports both downloading and uploading files.

```shell
# Download File from Web Server
curl http://<ip_addr>/<filename> -o <outfile>

# Download File from custom HTTPS Web Server
curl https://<ip_addr>/<filename> -o <outfile> -k

# Upload File to Web Server
curl -X POST -F "file=@<file_path>" http(s)://<ip_addr>/<filename>

# Upload File to custom HTTPS Web Server
curl -X POST -F "file=@<file_path>" http(s)://<ip_addr>/<filename> -k
```

**WGET**
- Supports only downloading files.

```shell
# Download File from Web Server
wget http://<ip_addr>/<filename> -O <outfile>

# Download File from custom HTTPS Web Server
wget https://<ip_addr>/<filename> -O <outfile> --no-check-certificate
```

### Downloading and Uploading via SMB
---

```shell
# Download File from Share
smbclient //<ip_addr>/share/ -N -c 'get <filename>'

# Upload File to Share
smbclient //<ip_addr>/share/ -N -c "put <filename>"
```

### Alternative Methods
---
Assuming SSH is enabled, you can use SCP.

```shell
# File Download via SCP
scp <username>@<ip_addr>:<file_path> <outfile>

# File Upload via SCP
scp <file_path> <username>@<ip_addr>:<out_path>
```