
### Overview
---
> [!info]
> The **Service** Github repository can be found [here](https://github.com/).

**Service** is a free, open-source, self-hosted... 

![[Pasted image 20231214113757.png]]

### Installation
---

> [!info]
> **Example LXC Hardware:**
>  - CPU: # cores
>  - RAM: # MB
>  - HDD: # GB

Installation will be done with the goal of avoiding Docker, as well as (optionally) have valid HTTPS certificates to make the service feel more refined.

#### Method 1: Scripted Installation

For scripted installation, my [ProxmoxMaster](https://github.com/tylerdotrar/ProxmoxMaster) repository can be utilized.

```shell
bash -c "$(wget -qO- https://github.com/tylerdotrar/ProxmoxMaster/raw/main/services/<service>.sh)"
```

![[Pasted image 20231214113845.png]]

#### Method 2: Manual Installation

##### Dependencies & Downloads

```shell
# Update, Upgrade, and Dependencies
apt update && apt upgrade -y
apt install -y 

# Download, install, and clean-up Service
uhhh....
```

##### Site Configuration

Once dependencies are installed, next is site configuration.  Do you want to run a simple HTTP site or do you want to go the extra mile and have a clean HTTPS setup?  For the latter, you can use [OPNsense as a local CA and create local certificates](../../01.%20Infrastructure/OPNsense/Creating%20Internal%20CA's%20and%20Certificates.md) for a homelab environment (example domain: `homelab`).

*(Note: alternatively you can use an [NGINX reverse proxy](../Web%20Configurations/NGINX%20Reverse%20Proxy.md) for HTTPS support)*

###### Option 1: HTTP

This configuration will allow you to access the site on port 80, with no further configuration.

```shell
# HTTP Site Configuration
uhhh....
```

###### Option 2: HTTPS

This configuration will allow you to access the site with a valid SSL certificate on port 443, but does require further configuration.

```shell
# HTTPS Site Configuration
uhhh....
```

For the above HTTPS configuration..

```
# Enable SSH to SCP certificates into LXC
nano /etc/ssh/sshd_config
-------------------------------
PermitRootLogin yes
-------------------------------
systemctl start sshd

	mkdir /etc/ssl/filegator

# Copy generated/downloaded SSL certificates from Host System
### scp <cert>.crt root@filegator:/etc/ssl/filegator/filegator.crt
### scp <cert>.key root@filegator:/etc/ssl/filegator/filegator.key
##### End SSL certificate steps
```

###### Bonus: Might not Exist

```shell
# Bonus Stuff Here
uhhh....
```

##### Finish Setup

```shell
uhhh....
```



