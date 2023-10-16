
**Requirements for Configuration:**
- NordVPN
- Linux Host


```
WireGuard Setup:
----------------
(Linux CLI Configuration)
sudo apt install wireguard
curl https://downloads.nordcnd.com/apps/linux/install.sh | sudo sh
curl ifconfig.me
sudo nordvpn login
sudo nordvpn set technology NordLynx
sudo nordvpn connect
curl ifconfig.me
sudo wg
ip address show nordlynx
sudo wg show nordlynx private-key

(Potential Windows CLI Configuration)
https://support.nordvpn.com/Connectivity/Windows/1350897482/Connect-to-NordVPN-app-on-Windows-using-the-Command-Prompt.htm


Local:
------
Name            : NordVPN
Public Key      : oJ7Sh0R110zLhQ6w3ZI1OzS2dQeyy0Jf0iMj9w1kiDI=
Private Key     : EJdPXa4KrnTVeA+VtRCJftOPQpLxDQg34eClXvQk41c=
Listen Port     : 55569
Tunnel Address  : 10.5.0.2/32
Peers:          : us8192.nordvpn.com

Endpoint:
---------
Name            : us8192.nordvpn.com
Public Key      : Ew0CPosTB0dTZRKx9XyAblENRsyey7gPhNmp64sceVo=
Allowed IPs     : 0.0.0.0/0
Endpoint Address: 185.93.0.116
Endpoint Port   : 51820


WireGuard / NordLynx Gateway
----------------------------
- Name                  : WAN_NordVPN
- Interface             : NordLynx
- Address Family        : IPv4
- IP Address            : 10.5.0.1
- Far Gateway           : [x]
- Disable GW Monitoring : [x]


Rules --> LAN
-------------
[Rule 1] Allow desired host(s) to travel through WireGuard gateway
- Action    : Pass
- Interface : LAN
- Source    : VPN_Test (Alias: desired host(s) to route through tunnel)
- Gateway   : WAN_NordVPN


Rules --> NAT --> Outbound
--------------------------
[x] Hybrid outbound NAT rule generation

[Rule 1] NAT desired host(s) to WireGuard interface
- Interface    : NordLynx
- Source       : VPN_Test (Alias: desired host(s) to route through tunnel)
- Trans/Target : Interface address


Rules --> NAT --> Port Foward
-----------------------------
[Rule] Remedy DNS leak
- Interface          : NordLynx
- Protocol           : TCP/UDP
- Source             : VPN_Test (Alias: desired host(s) to route through tunnel)
- Destination/Invert : [x]
- Destionation       : NordVPN_DNS (Alias: NordVPN public DNS servers)
- Destination Port   : DNS
- Redir Target IP    : NordVPN_DNS (Alias: NordVPN public DNS servers)
- Redir Target Port  : DNS
```
