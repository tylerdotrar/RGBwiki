
### Pre-Requisites
---
```
# Create Server Certificates from your internal Certificate Authority
(1) Include common name, DNS, IP, and URI.
(2) Download user certificate (.crt)
(3) Download user private key (.key)
(3) Create certificate bundle (.pem)
--- cat <servername>.key <servername>.crt > <servername>-bundle.pem


# Copy Certificates and Keys as needed
scp <servername>.crt <user>@<hostname>:/path/<servername>.crt
scp <servername>.key <user>@<hostname>:/path/<servername>.key
scp <servername>-bundle.pem <user>@<hostname>:/path/<servername>-bundle.pem
```


### Nginx
---
```shell
# Move Certificate and Key to Server
sudo mkdir /etc/ssl/<servername>
sudo cp <servername>.crt /etc/ssl/<servername>/<servername>.crt
sudo cp <servername>.key /etc/ssl/<servername>/<servername>.key


# Modify Available Site ('default' in this example)
echo "server { 
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;``
    
    ssl_certificate /etc/ssl/<servername>/<servername>.crt
    ssl_certificate_key /etc/ssl/<servername>/<servername>.key
    
    root /var/www/<servername>;
    # Adjust index files as needed
    index index.html index.htm index.nginx-debian.html;
    server_name <domain>;
}" > /etc/nginx/sites-available/default


# Restart the nginx service
sudo systemctl nginx restart
```


### Apache
---
```shell
# Move Certificate and Key to Server
sudo mkdir /etc/ssl/<servername>
sudo cp <servername>.crt /etc/ssl/<servername>/<servername>.crt
sudo cp <servername>.key /etc/ssl/<servername>/<servername>.key


# Modify Available Site ('default' in this example)
echo "
<VirtualHost *:443>
    DocumentRoot /var/www/<servername>
	ServerName <servername.com>
		SSLEngine on
		SSLCertificateFile /etc/ssl/<servername>/<servername>.crt
		SSLCertificateKeyFile /etc/ssl/<servername>/<servername>.key
</VirtualHost>
" > /etc/apache2/sites-available/<servername>.conf


# Restart the apache service
sudo systemctl apache restart
```


### Lighttpd
---
```shell
# Move Certificate Bundle to Server
sudo mkdir /etc/ssl/<servername>
sudo cp <servername>-bundle.pem /etc/ssl/<servername>/<servername>-bundle.pem


# Modify 'external.conf' (because 'lighttpd.conf' will be overwritten by updates)
echo 'server.modules += ( "mod_openssl" )

$HTTP["host"] == "<servername.com>" {
  # Ensure the Block Page knows that this is not a blocked domain
  setenv.add-environment = ("fqdn" => "true")

  # Enable the SSL engine with a cert, only for this specific host
  $SERVER["socket"] == ":443" {
    ssl.engine = "enable"
    ssl.pemfile = "/etc/ssl/<servername>/<servername>-bundle.pem"
    ssl.honor-cipher-order = "enable"
    ssl.cipher-list = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH"
    ssl.use-sslv2 = "disable"
    ssl.use-sslv3 = "disable"       
  }

  # Redirect HTTP to HTTPS
  $HTTP["scheme"] == "http" {
    $HTTP["host"] =~ ".*" {
      url.redirect = (".*" => "https://%0$0")
    }
  }
}' > /etc/lighttpd/external.conf


# Restart the lighttpd service
sudo service lighttpd restart
```