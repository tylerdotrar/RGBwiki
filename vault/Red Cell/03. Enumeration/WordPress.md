
### Overview
---
WordPress is a web content management system, aimed at providing tools and plugins for website building and developing.

Due to the scope of the WordPress ecosystem, the attack surface for WordPress websites is rather large and warrants its own scanner -- this is where [WPScan](https://github.com/wpscanteam/wpscan) comes into play.

> [!info]
> The **WPScan** WordPress security scanner is a CLI tool that uses the WordPress Vulnerability Database API to retrieve WordPress vulnerability data in real time.


### Enumeration
---
When enumerating a website, we need to know that WordPress is being used prior to using ``wpscan``.

- This can often be given away from ``nmap`` scans:
![[Pasted image 20230711023505.png]]
![[Pasted image 20230711023532.png]]

- Or via browser plugins such as [Wappalyzer](https://www.wappalyzer.com/apps/), which is a valuable tool for determining website backend frameworks and technologies.
![[Pasted image 20230711023313.png]]


### WPScan
---
Once WordPress has been identified, ``wpscan`` can be used to find individual plugins, versions, and potentials vulnerabilities.

**General Usage:**
```shell
wpscan --url <ip_addr>:<port>
```

![[Pasted image 20230215181435.png]]

- Vulnerabilities and versions should be prominently displayed.
![[Pasted image 20230711051223.png]]
![[Pasted image 20230711051343.png]]


> [!warning]
> It is worth noting that occasionally ``wpscan`` can have false negatives, not knowing that specific plugin versions are vulnerable.

- Example of ``wpscan`` finding a plugin, but not knowing about known exploits.
![[Pasted image 20230711050825.png]]
