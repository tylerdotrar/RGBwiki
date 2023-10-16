Notes created: 20SEP2022

```shell
### Hardware:  Given 1CPU, 512MB RAM, 4GB HDD

# Update, Upgrade, and Dependencies
apt update && apt upgrade -y
apt install -y nginx php php-fpm git

# Download, install, and clean-up FileGator repository
git clone https://github.com/causefx/Organizr /var/www/organizr

nano /etc/nginx/sites-enabled/default
-------------------------------
server { 
    # SSL Configuration
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    
    ssl on;
    
    ssl_certificate /etc/ssl/organizr/organizr.crt
    ssl_certificate_key /etc/ssl/organizr/organizr.key
    
    # Root directory
    root /var/www/organizr;
    
    # Add index.php to this list if you are using PHP
    index index.html index.htm index.nginx-debian.html index.php;
    
    # Specify the desired domain name
    server_name organizr;

    location / { try_files $uri $uri/ =404; }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        # Default socket is php7.4-fpm.sock, change this to whatever version PHP is being used
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    # Add this section
    location /api/v2 { try_files $uri /api/v2/index.php$is_args$args; }
}
-------------------------------
# Give the site write privileges
chown -R www-data:www-data /var/www/organizr/

# Install extra Organizr dependencies
apt install -y php-sqlite3 php-zip php-curl php-xml

# Enable SSH to SCP certificates into LXC
nano /etc/ssh/sshd_config
-------------------------------
PermitRootLogin yes
-------------------------------
systemctl start sshd

mkdir /etc/ssl/organizr
# Copy generated/downloaded SSL certificates from Host System
### scp <cert>.crt root@<organizr_ip>:/etc/ssl/organizr/organizr.crt
### scp <cert>.key root@<organizr_ip>:/etc/ssl/organizr/organizr.key

# Start Organizr
systemctl start nginx
```