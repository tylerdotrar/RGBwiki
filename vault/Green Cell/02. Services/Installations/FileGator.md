Notes created: 15NOV2022

```shell
### Hardware: LXC given 2 Cores, 2048MB RAM, 200G HDD ###

# Update, Upgrade, and Dependencies
apt update && apt upgrade -y
apt install -y wget unzip php apache2 libapache2-mod-php php-zip php-mbstring php-dom php-xml

# Download, install, and clean-up FileGator repository
cd /var/www/
wget https://github.com/filegator/static/raw/master/builds/filegator_latest.zip
unzip filegator_latest.zip && rm filegator_latest.zip


# Give the site write privileges
chown -R www-data:www-data filegator/
chmod -R 775 filegator/


# Site Configuration
echo "
<VirtualHost *:443>
    DocumentRoot /var/www/filegator/dist
	ServerName filegator.pen15
		SSLEngine on
		SSLCertificateFile /etc/ssl/filegator/filegator.crt
		SSLCertificateKeyFile /etc/ssl/filegator/filegator.key
</VirtualHost>
" >> /etc/apache2/sites-available/filegator.conf

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
