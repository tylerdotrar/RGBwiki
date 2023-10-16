
### ffuf
---
``Ffuf`` is a project heavily inspired by wfuzz written in Go. Works basically the same, in that you just replace the word you want to fuzz with FUZZ. 

**Installation:**
```bash
sudo apt install ffuf
```

**General Usage:**
```shell
ffuf -u "http(s)://<ip_addr>/FUZZ" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```


### wfuzz
---
``Wfuzz`` has been created to facilitate the task in web applications assessments and it is based on a simple concept: it replaces any reference to the FUZZ keyword by the value of a given payload.

**Filtering Options:**
```bash
--hs/ss "regex" #Hide/Show
#Simple example, match a string: "Invalid username"
#Regex example: "Invalid *"

--hc/sc CODE #Hide/Show by code in response
--hl/sl NUM #Hide/Show by number of lines in response
--hw/sw NUM #Hide/Show by number of words in response
--hh/sh NUM #Hide/Show by number of chars in response
--hc/sc NUM #Hide/Show by response code
```

**Output Options:**
```bash
wfuzz -e printers #Prints the available output formats
-f /tmp/output,csv #Saves the output in that location in csv format
```

**Encoders Options:**
```bash
wfuzz -e encoders #Prints the available encoders
#Examples: urlencode, md5, base64, hexlify, uri_hex, doble urlencode
```

**Directory Busting:**
```bash
#Filter by whitelisting codes
wfuzz -c -z file,/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --sc 200,202,204,301,302,307,403 http://example.com/uploads/FUZZ
```

**Subdomain Bruteforcing:**
```bash
wfuzz -w -H "Host: FUZZ.target-domain-name.com" /usr/share/wordlists/dirb/big.txt 127.0.0.1
```


### SecLists
---
``SecLists`` is the security tester's companion. It's a collection of multiple types of lists used during security assessments, collected in one place. List types include usernames, passwords, URLs, sensitive data patterns, fuzzing payloads, web shells, and many more.

**Installation:**
```bash
# In the Kali apt repos
sudo apt install seclists # Will then be found in /usr/share/seclists

# Or use the Github Repo
git clone https://github.com/danielmiessler/SecLists.git
```

