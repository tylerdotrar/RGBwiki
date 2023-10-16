
Below is one of the simplest and most straight forward tunnelling methods, useful for when you have SSH credentials to a box.
```shell
# Establish a tunnel into the network
ssh <user>@<ip_address> -p <ssh_port> -D <proxy_port>
# Send command through SOCKS tunnel
proxychains <command>
```

Above code would allow us to proxy commands on our attacker to reach the clients inside the network, assuming <client_01> is dual NIC'd and is our entry into the network.

Shitty Diagram Below:
```
						| FW |       <client_02>
<attacker_ip> ---> <client_01>:22    <client_03>
						| FW |       <client_04>
```
