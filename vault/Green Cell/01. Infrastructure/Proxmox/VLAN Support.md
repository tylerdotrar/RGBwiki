
The following note will be a VLAN Walkthrough using OPNsense & Proxmox.

### OPNsense VLAN Configuration
---

- **OPNSENSE -> Interfaces -> Other Types -> VLAN**
	- Chose Parent (physical) interface
	- Give new device name (vlan0.x) and VLAN tag x (e.g., vlan0.300, tag: 300)
	- Apply changes.

- **OPNSENSE -> Interfaces -> Assignments**
	- Select created VLAN device as 'New Interface'
	- Give the new interface a description (e.g., 'Example', etc.)
	- Select the "+" sign on the right (add)
	- Save changes.


- **OPNSENSE -> Interfaces -> \[Example]**
	- Enable interface
	- Set IPv4 Configuration Type to: "Static IPv4"
	- Input desired IP address and network CIDR for that interface (e.g., "10.10.10.1/25")
	- Save changes.

### Proxmox VLAN Configuration
---

- **PROXMOX -> Datacenter -> <node_name> -> System -> Network**
	- Create a Linux Bridge (vmbr)
	- Make it 'VLAN aware'
	- Bridge the physical port being used for the VLAN
	- Add a comment denoting what the bridge is for (e.g., "Example (Tag: 300)")
	- Create bridge.

- **PROXMOX -> Datacenter -> <node_name> -> System -> Network**
	- Create a Linux VLAN
	- Set the VLAN name as "<linux_bridge>.<vlan_tag>" (e.g., "vmbr1.300")
	- Set the IPv4/CIDR to match the VLAN interface assignment (e.g., "10.10.10.0/25")
	- NO gateway.
	- Add a comment denoting what the VLAN is for (e.g., "Example")
	- Create VLAN

- **PROXMOX -> Datacenter -> <node_name> -> System -> Network**
	- Select "Apply Configuration" to save changes.

### Creating LXC's and VM's
---

- **PROXMOX -> Create VM / Create CT**
	- Configure as you would any other virtual machine / LXC
	- Select the created Linux Bridge (vmbr) as the networking bridge.
	- Specify the VLAN tag to use (which should helpfully be noted in the bridge comment).




```
### VLAN Walkthrough using OPNsense & Proxmox

# OPNsense VLAN Configuration
> OPNSENSE -> Interfaces -> Other Types -> VLAN
- Chose Parent (physical) interface
- Give new device name (vlan0.x) and VLAN tag x (e.g., vlan0.300, tag: 300)
- Apply changes.

> OPNSENSE -> Interfaces -> Assignments
- Select created VLAN device as 'New Interface'
- Give the new interface a description (e.g., 'Example', etc.)
- Select the "+" sign on the right (add)
- Save changes.

> OPNSENSE -> Interfaces -> [Example]
- Enable interface
- Set IPv4 Configuration Type to: "Static IPv4"
- Input desired IP address and network CIDR for that interface (e.g., "10.10.10.1/25")
- Save changes.

# Proxmox VLAN Configuration
> PROXMOX -> Datacenter -> "YourNodeName" -> System -> Network
- Create a Linux Bridge (vmbr)
- Make it 'VLAN aware'
- Bridge the physical port being used for the VLAN
- Add a comment denoting what the bridge is for (e.g., "Example (Tag: 300)")
- Create bridge.

> PROXMOX -> Datacenter -> "YourNodeName" -> System -> Network
- Create a Linux VLAN
- Set the VLAN name as "<linux_bridge>.<vlan_tag>" (e.g., "vmbr1.300")
- Set the IPv4/CIDR to match the VLAN interface assignment (e.g., "10.10.10.0/25")
- NO gateway.
- Add a comment denoting what the VLAN is for (e.g., "Example")
- Create VLAN

> PROXMOX -> Datacenter -> "YourNodeName" -> System -> Network
- Select "Apply Configuration" to save changes.

# Creating LXC's and VM's
> PROXMOX -> Create VM / Create CT
- Configure as you would any other virtual machine / LXC
- Select the created Linux Bridge (vmbr) as the networking bridge.
- Specify the VLAN tag to use (which should helpfully be noted in the bridge comment).
```