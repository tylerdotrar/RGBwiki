
>[!info]
>Requires elevated privileges to run.

### Overview
---

Within elevated sessions, you can unload different drivers to reduce visibility and collection.  A prime example of this would be using the built-in ``fltmc`` tool.

![[Pasted image 20231002172906.png]]

The ``fltmc`` tool is a command-line utility in Microsoft Windows used to manage and query the status of the filter drivers that are installed on a system. Filter drivers are software components that intercept and modify data as it passes between software components and hardware devices. These filter drivers are often used for various purposes, including:

1. **File System Filters**: File system filter drivers are commonly used for tasks such as antivirus scanning, encryption, compression, and real-time file access monitoring.
    
2. **Device Driver Filters**: Device driver filter drivers can be used for tasks like monitoring and controlling input and output to devices, such as printers or storage devices.
    
3. **Network Filters**: Network filter drivers are used for tasks such as firewalling, intrusion detection, and network packet inspection.

### Example
---

An example of use case would be utilizing ``fltmc`` to unload Sysmon during an engagement to reduce defender visibility.

```powershell
# List currently loaded drivers
fltmc

# Unload Sysmon Driver
fltmc unload SysmonDrv
```

- Example output from a Sliver beacon
![[Pasted image 20231002182646.png]]