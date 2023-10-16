Notes created: 24OCT2022

```shell
### Hardware: Minimum/Default Specs (1 Core, 512MB RAM, 8G HDD)

# Update, Upgrade, and Dependencies
apt update && apt upgrade -y
apt install -y nginx git unzip

# Download, install, and clean-up Homer repository (+ custom Homer Theme)
wget https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip
git clone https://github.com/walkxcode/homer-theme
mkdir /var/www/homer
unzip homer.zip -d /var/www/homer
cp -rf homer-theme/assets /var/www/homer
rm -rf homer.zip homer-theme


# Basic Configuration
nano /etc/nginx/sites-enabled/default
-------------------------------
server { 
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    
    ssl on;
    ssl_certificate /etc/ssl/homer/homer.crt
    ssl_certificate_key /etc/ssl/homer/homer.key
    
    root /var/www/homer;
    index index.html index.htm index.nginx-debian.html;
    server_name homer;
}
-------------------------------
# Give the site write privileges
chown -R www-data:www-data /var/www/homer/


##### These next steps are specifically for pulling SSL certificates
# Enable SSH to SCP certificates into LXC
nano /etc/ssh/sshd_config
-------------------------------
PermitRootLogin yes
-------------------------------
systemctl start sshd


mkdir /etc/ssl/home

# Copy generated/downloaded SSL certificates from Host System
### scp <cert>.crt root@<homer_ip>:/etc/ssl/homer/homer.crt
### scp <cert>.key root@<homer_ip>:/etc/ssl/homer/homer.key
##### End SSL certificate steps

# Start Homer
systemctl enable nginx
```