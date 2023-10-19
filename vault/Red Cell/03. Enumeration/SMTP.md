(Thank you [@numonce](https://github.com/numonce))
## Overview
---
- SMTP is a service that can be found in most infrastructure penetration tests. This service can help the penetration tester to perform username enumeration via the EXPN and VRFY commands if these commands have not been disabled by the system administrator.

## smtp-user-enum
---
- A tool that can be used is `smtp-user-enum` which provides 3 methods of user enumeration.
	- The commands that this tool is using in order to verify usernames are the **EXPN**,**VRFY** and **RCPT**. It can also support single username enumeration and multiple by checking through a .txt list. So in order to use this tool effectively you will need to have a good list of usernames. 

```shell
# Check if SMTP users in users.txt exist
smtp-user-enum -M VRFY -U users.txt -t <ip_addr>

# Check if SMTP users in users.txt exist w/ a valid email addresses
smtp-user-enum -M VRFY -D <target_domain> -U users.txt -t <ip_addr>
```