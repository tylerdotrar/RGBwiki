
### Overview
---
- One of the easiest and quickest privilege escalation techniques is to check if there is a vulnerable misconfiguration in the ``/etc/sudoers`` file.  This file indicates what binaries can be ran with elevated privileges, meaning if specifically vulnerable binaries are allowed to be executed with sudo it could potentially result in privilege escalation.


### Exploitation Example
---
- For this method, the user's password must be known _OR_ the user must have the ``NOPASSWD`` flag set in ``/etc/sudoers``.
```
# EVERYTHING ran but requires knowing the user's password
root ALL=(ALL:ALL) ALL 

# EVERYTHING ran without a password 
user1 ALL=(ALL:ALL) NOPASSWD: ALL

# SPECIFIC program doesn't require a password 
user2 ALL=(ALL:ALL) NOPASSWD: /usr/bin/vi
```

- Check current sudo privileges and sudo-able programs that don't require passwords:
```shell
sudo -l
```

- If any common binaries are specified, cross-reference https://gtfobins.github.io/#+sudo to see if there are any known exploits.
![[Pasted image 20230711042051.png]]

- If ``(ALL : ALL) ALL`` is specified, you can escalate to the root user using ``sudo su`` if you know the current user's password.
![[Pasted image 20230711041947.png]]
