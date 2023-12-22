
### Pre-Exploitation
---

- [ ] **Port Scanning**
	- Do I need to adjust my scan to avoid detection?
	- Will the host block ICMP? Do I need to use `-Pn`?
```bash
# Scan ALL Ports, OS Detection, and Run All "*vuln*" Scripts
rustscan -a <ip_addr> -- -O --script vuln

# Nmap Eqiuvalent
sudo nmap <ip_addr> -p- -O --script vuln 
```


- [ ] **Web Technology Enumeration**
	- Is the server running any web services?
	- What language is the site using? `.php`? `.aspx`?
```
# Wappalyzer Plugin Output
```
![[Pasted image 20231215153037.png]]


- [ ] **Web Fuzzing**
	- Do I need to adjust my fuzz to account for the site language?
	- Are there any hidden subdomains?
```bash
# Directory Fuzzing
sudo ffuf -u http(s)://<ip_addr>:<port>/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

# Subdomain Fuzzing
sudo ffuf -u "http://<domain>:<port>" -H "Host: FUZZ.<domain>" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -fc 302
```

- [ ] **Enum4Linux:**
	- Is port 445 open?
```bash
# Windows/Samba Enumeration
sudo enum4linux -v <ip_addr>
```


- [ ] **SMB**
	- Is port 445 open?
	- Can I authenticate with null credentials?
```shell
# Attempt Null Cred SMB Authentication
smbmap -H <ip_addr> -u " "
```


- [ ] **FTP**
	- Is port 21 open?
	- Is anonymous logon authorized?
```shell
# Attempt anonymous FTP login (anonymous:anonymous)
ftp <ip_addr>
> Username: anonymous
> Password: anonymous
```


**Notes:**
1. Operating System:
2. Domain:
3. Known Service(s) / Version(s): 
4. Potential Vulnerabilities / CVE's: 


**Search Github for Potential CVE PoC's:**
```
https://github.com/search?q=<cve>
```


### Post Exploitation
---

- [ ] What are my privileges?
- [ ] What services are running?
- [ ] What current network connections are there?
- [ ] What files can I execute?
- [ ] Are there any files or variables containing credentials?
