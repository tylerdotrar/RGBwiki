## Overview
---
- The purpose of this note is to cover some of the key points of Windows authentication, excluding Kerberos

> [!info]
> For a Kerberos overview, see my Kerberos [Authentication Overview](../01.%20Active%20Directory%20(AD)/Kerberos%20Overview/Authentication%20Overview.md) note.

- **BLUF:**
	1. **SAM** is the local database in a Windows system that holds use account information.
	2. **LSASS** is the system service that interacts with the SAM database to authenticate users and handle other security tasks. 
	3. **NTLM** is a suite of authentication protocols utilized by LSASS to verify the identity of users based on the credentials stored in the SAM database.

## LSASS vs SAM
---
- **SAM**:
	- The **SAM (Security Accounts Manager)** database is a part of the Windows Registry and stores user account information, including usernames, password hashes, and security policies.
	- It is the primary source of local user account data on a Windows system.

- **LSASS**:
	- **LSASS (Local Security Authority Subsystem Service)** is a crucial system service in Windows responsible for managing user authentication and enforcing security policies.
	- It interacts with the SAM database to handle user logins, verify credentials, and govern access controls, making it integral to the security of Windows-based systems.

##### Dumping LSASS
- When dumping LSASS, you are dumping the running `lsass.exe` process memory.  This contains hashes for the currently logged on users, because...
	- Password hashes are stored in LSASS memory after a user successfully authenticates during login. 
	- Storing these hashes in memory allows LSASS to avoid querying the SAM database every time the user needs to authenticate for a resource or access a service.
	- Once a user has authenticated, their password hash is cached in LSASS memory for subsequent authentication requests, making the process more efficient and avoiding the need to repeatedly access the SAM database for the same user.

## NTLM
---
While LSASS is the service that manages authentication with the SAM database, **NTLM (NT LAN Manager)** is the suite of authentication protocols LSASS utilizes for the negotiation and verification of user identities based on NTLM hashes (as well as challenge-response mechanisms).

What are NTLM hashes? 

### NTLM vs Net-NTLM
##### NTLM (NTLMv1):
- These hashes are stored in the SAM database and/or in the Domain Controller's `NTDS.dit` database.
- NTLMv1 hashes look like this:

```
aad3b435b51404eeaad3b435b51404ee:e19ccf75ee54e06b06a5907af13cef42
              LM                :             NT
```

##### Net-NTLM (NTLMv2):
- These hashes are used for network authentication.  They are derived from a challenge/response algorithm and are based on the user's NT hash.
- NTLMv2 hashes Looks like this:

```
admin::N46iSNekpT:08ca45b7d7ea58ee:88dcbe4446168966a153a0064958dac6:5c7830315c7830310000000000000b45c67103d07d7b95acd12ffa11230e0000000052920b85f78d013c31cdb3b92f5d765c783030
```

##### Pass-The-Hash:
- You **CAN** perform Pass-The-Hash attacks with **NTLM** hashes.
- You **CANNOT** perform Pass-The-Hash attacks with **Net-NTLM** hashes. However, they can be used to perform relay attacks.