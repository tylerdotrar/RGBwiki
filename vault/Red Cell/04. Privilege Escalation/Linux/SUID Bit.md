
### Overview
---
Another quick and easy privilege escalation method is to check if any known programs contain the set-UID bit that may retain privileges.


### Exploitation Example
---
- The following command(s) can be used to determine if the SUID bit is set:
```shell
# The program will run as the owner of the file
find / -perm -4000 2>/dev/null 
# The program will run as the group of the file 
find / -perm -2000 2>/dev/null 
# The program will run as both the owner and the group 
find / -perm -6000 2>/dev/null
```

- If any common binaries are found, cross-reference https://gtfobins.github.io/#+suid to see if there are any known exploits.

![[Pasted image 20230711013611.png]]
![[Pasted image 20230711014359.png]]
![[Pasted image 20230711013825.png]]
