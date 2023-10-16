Notes created: 08JUN2023

```shell
=========================
PASSBOLT LXC INSTALLATION
=========================
## Using Ubuntu 22.04 ##


# Configure SSH
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl enable ssh --now

mkdir /etc/ssl/passbolt

### On Host ###

# Create Server Certificates from your internal Certificate Authority
(1) Include common name, DNS, IP, and URI.
(2) Download user certificate (.crt)
(3) Download user private key (.key)

scp .\Passbolt+Certificate.crt root@passbolt:/etc/ssl/passbolt/passbolt.crt
scp .\Passbolt+Certificate.key root@passbolt:/etc/ssl/passbolt/passbolt.key

### SSH to Server

# Update
apt update && apt upgrade -y

# Download Dependencies, SHA512SUM, Install, and Cleanup
wget "https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh"
wget https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt

sha512sum -c passbolt-ce-SHA512SUM.txt && bash ./passbolt-repo-setup.ce.sh || echo \"Bad checksum. Aborting\" && rm -f passbolt-repo-setup.ce.sh

rm -f passbolt-repo-setup.ce.sh passbolt-ce-SHA512SUM.txt
apt install figlet passbolt-ce-server -y


==========
GUI CONFIG
==========
MySQL
-----
MySQL Admin User: 	root (default)
MySQL Admin Password:	NULL (default)
MySQL Passbolt User: 	passboltadmin (default)
Passbolt Database:	passboltdb (default)

Manual SSL Config
-----------------
Domain:		<ip_address>
SSL Cert:	/etc/ssl/passbolt/passbolt.crt
SSL Key:	/etc/ssl/passbolt/passbolt.key

OpenPGP Key (doesn't matter)
-----------
Server Name:	passbolt.pen15
Server Email:	passbolt@example.com

Email Configuration (doesn't matter)
-------------------
Sender Name:	Passbolt
Sender Email:	passbolt@example.com
SMTP Host:	smtp.passbolt.pen15

User
----
<username>@example.com


=================================
CUSTOM SCRIPTS BECAUSE FUCK EMAIL
=================================
---------------
recover_user.sh
---------------
#!/bin/bash

# Author: Tyler McCann (tylerdotrar)
# Arbitrary Version Number: 1.0.0
# Link: https://github.com/tylerdotrar/<tbd>

Domain="https://passbolt.pen15"

figlet "Passbolt"
echo "$(tput setaf 3)Input Username:$(tput setaf 7)"
read Username
echo

Output=$(su -c "/usr/share/php/passbolt/bin/cake passbolt recover_user --create --username $Username" -s /bin/bash www-data) || exit 1
Recovery=$(echo $Output | awk '{print $NF}' | tail -n 1)

echo "$(tput setaf 3)Recovery Link:$(tput setaf 7)"
echo "$Domain$Recovery"
``


----------------
register_user.sh
----------------
#!/bin/bash

# Author: Tyler McCann (tylerdotrar)
# Arbitrary Version Number: 1.0.0
# Link: https://github.com/tylerdotrar/<tbd>

Domain="https://passbolt.pen15"

figlet "Passbolt"
echo "$(tput setaf 3)Input Username:$(tput setaf 7)"
read Username
echo
echo "$(tput setaf 3)Input First Name:$(tput setaf 7)"
read Fname
echo
echo "$(tput setaf 3)Input Last Name:$(tput setaf 7)"
read Lname
echo
echo "$(tput setaf 3)Input Role ('admin' or 'user'):$(tput setaf 7)"
read Role
echo

Output=$(su -c "/usr/share/php/passbolt/bin/cake passbolt register_user -u $Username -f $Fname -l $Lname -r $Role" -s /bin/bash www-data) || exit 1
Register=$(echo $Output | awk '{print $NF}' | tail -n 1)

echo "$(tput setaf 3)Registration Link:$(tput setaf 7)"
echo "$Domain$Register"
``
```