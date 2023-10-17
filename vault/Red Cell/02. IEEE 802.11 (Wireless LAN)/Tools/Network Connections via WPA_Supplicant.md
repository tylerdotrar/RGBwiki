## WPA_Supplicant
---
**Usage Syntax**
```shell
# Connect to wireless network via CLI
sudo wpa_supplicant -i <wlan_interface> -c wifi-client.conf

# Renew DHCP after connecting to network
sudo dhclient <wlan_interface>
```

## Network Configuration Files
---
##### WPA2-PSK Configuration
```shell
# wifi-client.conf
network={
  scan_ssid=1
  ssid="<ssid>"
  psk="<passphrase>"
  key_mgmt=WPA-PSK
}
```

##### WPA2-MGT Configuration
```shell
# wifi-client.conf
network={
  ssid="<ssid>"
  identity="<domain>\<user>"
  password="<passphrase>"
  scan_ssid=1
  eap=PEAP
  key_mgmt=WPA-EAP
  phase1="peaplabel=0"
  phase2="MSCHAPV2"
}
```

##### WEP Configuration
```shell
# wifi-client.conf
network={
  ssid="<ssid>"
  scan_ssid=1
  key_mgmt=NONE
  wep_tx_keyidx=0
  wep_key0=<network_key>
}
```