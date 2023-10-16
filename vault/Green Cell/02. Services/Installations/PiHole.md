Notes created: 23MAR2023

NEEDS TO BE IRONED OUT

```shell
# Update System
sudo apt update && sudo apt upgrade -y

# Install PiHole
bash -c "$(wget -qO- https://install.pi-hole.net)"
### https://docs.pi-hole.net/main/basic-install/

# Set Password
pihole -a -p

### Add adlists via CLI
### PseudoCode
for ($URL in $List) {
	sudo sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (address, enabled, comment) VALUES ('$URL', 1, 'Comment Here');"
}

# Update Gravity
pihole -g

# Install Custom Certificate for HTTPS Web Portal

### Generate Internal Server Certificate on OPNsense
### Download Certificate and Key

# Copy Certificate and Private Key to Server
scp <domain>.crt <user>@<hostname>:/path/<domain>.crt
scp <domain>.key <user>@<hostname>:/path/<domain>.key

# Create bundled PEM certificate
cat <domain>.key <domain>.crt > <domain>-bundle.pem

# Move Bundled Certificate to lighttpd Directory
sudo mkdir /etc/lighttpd/certs
sudo cp <domain>-bundle.pem /etc/lighttpd/certs/<domain>-bundle.pem

# Modify 'external.conf' (because 'lighttpd.conf' will be overwritten by Pi-Hole updates)
sudo nano /etc/lighttpd/external.conf
``
server.modules += ( "mod_openssl" )

$HTTP["host"] == "<domain>" {
  # Ensure the Pi-hole Block Page knows that this is not a blocked domain
  setenv.add-environment = ("fqdn" => "true")

  # Enable the SSL engine with a cert, only for this specific host
  $SERVER["socket"] == ":443" {
    ssl.engine = "enable"
    ssl.pemfile = "/etc/lighttpd/certs/<domain>-bundle.pem"
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
}
``

# Restart the lighttpd service
sudo service lighttpd restart
```