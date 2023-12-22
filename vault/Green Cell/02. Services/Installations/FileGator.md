
### Overview
---
> [!info]
> The **FileGator** Github repository can be found [here](https://github.com/filegator/filegator).

**FileGator** is a free, open-source, self-hosted web application for file storage and management.  It allows you to store and organize files & folders, while also having multi-user support so you can have admins and other users managing files with different access permissions, roles and home folders.

![[Pasted image 20231213135650.png]]

### Installation
---

> [!info]
> **Example LXC Hardware:**
>  - CPU: 2 cores
>  - RAM: 2048 MB
>  - HDD: 200 GB

Installation will be done with the goal of avoiding Docker, as well as (optionally) have valid HTTPS certificates to make the service feel more refined.

#### Method 1: Scripted Installation

For scripted installation, my [ProxmoxMaster](https://github.com/tylerdotrar/ProxmoxMaster) repository can be utilized.

```shell
# Filegator Install
bash -c "$(wget -qO- https://github.com/tylerdotrar/ProxmoxMaster/raw/main/services/filegator.sh)"
```

#### Method 2: Manual Installation

##### Dependencies & Downloads

```shell
# Update, Upgrade, and Dependencies
apt update && apt upgrade -y
apt install -y wget unzip php apache2 libapache2-mod-php php-zip php-mbstring php-dom php-xml

# Download, install, and clean-up FileGator repository
cd /var/www/
wget https://github.com/filegator/static/raw/master/builds/filegator_latest.zip
unzip filegator_latest.zip
rm filegator_latest.zip
```

##### Site Configuration

Once dependencies are installed, next is site configuration.  Do you want to run a simple HTTP site or do you want to go the extra mile and have a clean HTTPS setup?  For the latter, you can use [OPNsense as a local CA and create local certificates](../../01.%20Infrastructure/OPNsense/Creating%20Internal%20CA's%20and%20Certificates.md) for a homelab environment (example domain: `homelab`).

*(Note: alternatively you can use an [NGINX reverse proxy](../Web%20Configurations/NGINX%20Reverse%20Proxy.md) for HTTPS support)*

###### Option 1: HTTP

This configuration will allow you to access the site on port 80, with no further configuration.

```shell
# HTTP Site Configuration
echo "
<VirtualHost *:80>
    DocumentRoot /var/www/filegator/dist
</VirtualHost>
" >> /etc/apache2/sites-available/filegator.conf
```

###### Option 2: HTTPS

This configuration will allow you to access the site with a valid SSL certificate on port 443, but does require further configuration.

```shell
# HTTPS Site Configuration
echo "
<VirtualHost *:443>
    DocumentRoot /var/www/filegator/dist
	ServerName filegator.homelab
		SSLEngine on
		SSLCertificateFile /etc/ssl/filegator/filegator.crt
		SSLCertificateKeyFile /etc/ssl/filegator/filegator.key
</VirtualHost>
" >> /etc/apache2/sites-available/filegator.conf
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

###### Bonus: Adjust Maximum File Size

```shell
# Modify configuration file to allow for larger file uploads
in /var/www/filegator/configuration.php
-------------------------------
'upload_max_size' => 10000 * 1024 * 1024, // 10,000MB (10GB)
-------------------------------
```

##### Setup Apache

```shell
# Give the site write privileges
chown -R www-data:www-data filegator/
chmod -R 775 filegator/

# Apache Configuration
a2enmod ssl
a2dissite 000-default.conf
a2ensite filegator.conf
systemctl enable apache2 --now
```


```

# Modify configuration file to allow for larger file uploads
-------------------------------
'upload_max_size' => 10000 * 1024 * 1024, // 10,000MB (10GB)
-------------------------------

##### These next steps are specifically for pulling SSL certificates
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

# Give the site write privileges
chown -R www-data:www-data filegator/
chmod -R 775 filegator/

# Apache Configuration
a2enmod ssl
a2dissite 000-default.conf
a2ensite filegator.conf
systemctl enable apache2

============================================
echo "<VirtualHost *:${server_port}>
    DocumentRoot /var/www/filegator/dist
    #ServerName filegator
        ${comment}SSLEngine on
        ${comment}SSLCertificateFile ${cert_path}
        ${comment}SSLCertificateKeyFile ${key_path}
</VirtualHost>" > /etc/apache2/sites-available/filegator.conf

line=$(grep -n 'upload_max_size' /var/www/filegator/configuration.php | cut -f1 -d:)
sed -i "${line}s/100/${max_file_size}/" /var/www/filegator/configuration.php

sed "s/'upload_max_size' => 100/'upload_max_size' => ${max_file_size}/" /var/www/filegator/configuration.php
sed "s/100MB/100MB changed to ${max_file_size}MB/" /var/www/filegator/configuration.php
sed -i "s/Listen 80/Listen sexy/" /etc/apache2/ports.conf

```


