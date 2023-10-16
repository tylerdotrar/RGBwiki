Original note created: 25JAN2023

- These notes are for setting up host collection using WinLogBeat with SecurityOnion.
- This page will be updated and enriched in the future.

```
[+] Download sysmon, and utilize below config file:
https://download.sysinternals.com/files/Sysmon.zip
https://github.com/SwiftOnSecurity/sysmon-config

Syntax:
.\sysmon64.exe -i .\sysmonconfig-export.xml


[+] Download Winlogbeat directly from the SOC to make sure the host and server are using the same versions


[+] Run 'sudo so-allow' on SO and set Logstash Beat (5044/tcp) to allow traffic from anything within the desired subnet.


[+] Navigate to "C:\ProgramData\Elastic\Beats\winlogbeat"


[+] Copy 'winlogbeat.example.yml' to 'winlogbeat.yml' and modify it to:

``
#=== Winlogbeat specific options ===
winlogbeat.event_logs:
  - name: Application
    ignore_older: 72h
  - name: System
  - name: Security
  - name: Microsoft-Windows-Sysmon/Operational
  - name: Microsoft-Windows-PowerShell/Operational

#=== Logstash output ===
output.logstash:
  # The Logstash hosts
  hosts: ["<SECONION_NAME>:5044"]
``

Note:
Make sure you specify the SecOnion name IF you setup DNS resolution/FQDN.
If you didn't, use the IP -- this can make or break host collection.

[+] Start 'Elastic Winlogbeat-Oss' service.
```