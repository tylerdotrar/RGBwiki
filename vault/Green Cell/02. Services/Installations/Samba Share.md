Notes Updated: 26AUG2023

```shell
# ========================
# SAMBA SHARE INSTALLATION
# ========================

apt update && apt upgrade -y
apt install samba
mkdir /SHARE

# Password-less Authentication
useradd --system shareuser
chown -R shareuser /SHARE

echo "
[ShareName]
  path = /SHARE
  browseable = yes
  writeable = yes
  read only = no
  guest ok = yes
  guest account = shareuser
  create mask = 0644
  directory mask = 0755
  force user = shareuser
  hide dot files = no
  acl allow execute always = true
" >> /etc/samba/smb.conf

systemctl enable smbd --now
```
