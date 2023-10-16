
Documentation can be found here:
- https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-bridged-wireless-access-point

```shell
# Variables
ethernetInt="eth0"
ethernetIP="xx.xx.xx.xx/24"
ethernetGateway="xx.xx.xx.xx"
ethernetDNS="xx.xx.xx.xx xx.xx.xx.xx"

wirelessInt="wlan0"
ssid="<ssid>"
pass="<password>"


# Updates and Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install hostapd


# Enable systemctl on start
sudo systemctl unmask hostapd
sudo systemctl enable hostapd


# Create a Bridge device
sudo echo "[NetDev]
Name=br0
Kind=bridge
" > /etc/systemd/network/bridge-br0.netdev


# Add ethernet interface to bridge
sudo echo "[Match]
Name=${ethernetInt}

[Network]
Bridge=br0
" > /etc/systemd/network/br0-member-${ethernetInt}.network


# Enable service to populate bridge on boot
sudo systemctl enable systemd-networkd --now


# (WIP) Add following lines above first "interface xxx" line
sudo nano /etc/dhcpcd.conf
`
# Added for AP configuration (1).
denyinterfaces ${wirelessInt} ${ethernetInt}
`


# Add folling lines at the end of the file
sudo echo "# Added for AP configuration (2).
interface br0
interface ${ethernetInt}
        static ip_address=${ethernetIP}
        static routers=${ethernetGateway}
        static domain_name_servers=${ethernetDNS}
" >> /etc/dhcpcd.conf


# Ensure WiFi radio is not blocked on the device
sudo rfkill unblock wlan


# Configure Hostapd AP Software
echo "# Interface in Bridged AP Mode
country_code=US
interface=${wirelessInt}
bridge=br0
macaddr_acl=0

# 5GHz
#hw_mode=a
#channel=153

# 2.4GHz
hw_mode=g
channel=7

# Authorization
ignore_broadcast_ssid=0
auth_algs=1
wpa=2
ssid=${ssid}
wpa_passphrase=${pass}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

# Hopefully Improve Speeds
ieee80211ac=1
wmm_enabled=1
require_ht=1
require_vht=1
" > /etc/hostapd/hostapd.conf


# Reboot
sudo systemctl reboot
```
