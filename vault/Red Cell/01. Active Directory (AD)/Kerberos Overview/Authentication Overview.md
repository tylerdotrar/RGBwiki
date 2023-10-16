
>[!info]
>This note is still in development.


![[Pasted image 20231015203512.png]]

### TL;DR
---
#### TGT Requests/Responses

##### AS-REQ (with PREAUTH):
- Request for a Ticket-Granting-Ticket (TGT), containing the user's User Principal Name (UPN) and a timestamp that is encrypted with the client's key (aka user's NTLM hash).
	- Sent from Client to Authentication Service (AS)
	- The encrypted timestamp is PREAUTH portion.
	- **Shared Key:**
		- **Key:** the user's NTLM hash
		- **Shared Between:** Client and the Authentication Service (AS)

##### AS-REP (with PREAUTH):
- A Ticket-Granting-Ticket (TGT) is returned that is encrypted with the KRBTGT hash and signed with the client's key IF the PREAUTH is validated.
	- Sent from Authentication Service (AS) to Client
	- A TGT is returned after validation is done, by decrypting the timestamp with the NTLM hash stored in the Kerberos Database (AD) for that specific UPN.
	- **Shared Key:**
		- **Key:** the KRBTGT NTLM hash
		- **Shared Between:** AS and the Ticket-Granting-Service (TGS)

##### AS-REQ (without PREAUTH):
- Request for a Ticket-Granting-Ticket (TGT), containing only the user's User Principal Name (UPN).
	- Sent from Client to Authentication Service (AS)
	- **Shared Key:**
		- **Key:** n/a
		- **Shared Between:** n/a

##### AS-REP (w/o PREAUTH):** 
- A Ticket-Granting-Ticket (TGT) is returned that is encrypted with the KRBTGT hash and signed with the client's key WITHOUT validating any PREAUTH.
	- Sent from Authentication Service (AS) to Client
	- A TGT is returned for that specific UPN without authentication.
	- **Shared Key:**
		- **Key:** the KRBTGT NTLM hash
		- **Shared Between:** AS and the Ticket-Granting-Service (TGS)

### Pre-Authentication
---
#### Example Authentication for a Client to access a Network File Service

![[Pasted image 20230824195249.png]]

**(1) AS-REQ:**
- Client sends authentication request to Authentication Service (AS), which is partially encrypted with their password used as the secret key.

![[Pasted image 20230824194533.png]]

**(2) AS-REP:**
- Authentication Service (AS) verifies client authentication by referencing the Kerberos Database for the the requested user's secret key.  If that secret key exists in the Kerberos Database and successfully decrypts the authentication request, the AS returns a Ticket-Granting-Ticket (TGT)  which is encrypted with a key shared between the AS and the Ticket-Granting-Service (TGS).

![[Pasted image 20230824194643.png]]

**(3)  TGS-REQ**

