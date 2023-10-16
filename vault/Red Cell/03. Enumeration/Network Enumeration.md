
There are multiple ways to enumerate the network, but here are a couple different methods that don't require any tunneling or port forwarding.

### Powershell
---

```powershell
# See other computers that have touched the current one in some way
net view

# View networking information (including if the box is dual NIC'd)
ipconfig /all

# /24 Ping Sweep
$TargetNetwork = "<first.three.octets>"
1..255 | % {echo "$TargetNetwork.$_"; ping -n 1 -w 100 "$TargetNetwork.$_" | Select-String ttl}

# /24 NSLOOKUP Scan
$TargetNetwork = "<first.three.octets>"
1..255 | % {echo "IP: $TargetNetwork.$_"; nslookup "$TargetNetwork.$_" | Select-String Name >> 192-168-1-0.txt}

# 1024 Port Scan (Very Slow)
$TargetIP = "<ip_address>"
1..1024 | % {echo ((New-Object Net.Sockets.TcpClient).Connect($TargetIP,$_)) "Port $_ is open!"} 2>$null

# Load "Invoke-PortScan.ps1" into session.  
# - Already on Kali, or can be downloaded from: https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/Invoke-Portscan.ps1
# - Requires AMSI bypass or disabled AV
iex ([System.Net.WebClient]::new().DownloadString('<script_url>'))
Invoke-Portscan -Hosts 192.168.1.1/24 -TopPorts 25
```


### Nmap
---
- TCP Scan ALL ports, get OS info, and do a vulnerability scan
```bash
sudo nmap <hostname or IP/CIDR> -p- -A --script vuln
```

If above returns nothing, attempt a UDP scan.  Either add ``-Pn`` or ``-sU`` for a UDP scan.

- UDP Scan
```bash
nmap -sU <hostname or ip/CIDR>
```


### Rustscan
---
``rustscan`` is effectively a wrapper for ``nmap`` written in rust -- by default it rapidly scans ALL ports then feeds the up ports to ``nmap`` for a more granular enumeration.

##### Installation
```shell
# Install Rust and Cargo
curl https://sh.rustup.rs -sSf | sh
rustup
# Install Rustscan
cargo install rustscan
```

##### Usage
```bash
rustscan -a <hostname or IP/CIDR> --ulimit 500 -- <nmap_args>
# -a = target address(s) / network
# -u = adjusts the amount of open sockets at a given time
# -- = pass nmap arguments to rustscan
```
- Note: ``ulimit`` of 500 slows the scan down, but prevents (rare) false positives

```shell
# Example:
rustscan -a 192.168.108.124 -u 500 -- -A --script vuln
```
![[Pasted image 20230306133814.png]]
