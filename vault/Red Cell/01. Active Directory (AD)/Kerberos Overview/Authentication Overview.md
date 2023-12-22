
>[!info]
>This note is still in development.

Before reading, make sure you are familiar with Kerberos components and their correlated acronyms.  Please reference the [Component Overview](./Component%20Overview.md) for an overview.
## BLUF
---

- Kerberos uses a series of symmetric keys for user authentication.
	- **Shared Key 1:** User's NTLM hash between the end-user and Authentication Service (AS).
	- **Shared Key 2:**  KRBTGT NTLM hash between the Authentication Service (AS) and Ticket-Granting-Service (TGS).
	- **Shared Key 3:** Service's NTLM hash between the Ticket-Granting-Service (TGS) and the target service.

### Order of Operations

1. **Requesting a Ticket Granting Ticket (TGT) from the Authentication Service (AS)**
	- **AS-REQ:** User requests Ticket-Granting-Ticket (TGT) by encrypting a timestamp with the NTLM hash of the requested user, and sends it to the Authentication Service (AS).
	- **AS-REP:** The AS returns a TGT encrypted with the KRBTGT hash if it can successfully decrypt the timestamp using the requested user's NTLM hash that's stored in AD and if the timestamp is accurate.
2. **Requesting a Service Ticket (ST) from the Ticket Granting Service (TGS)**
	- **TGS-REQ:** Authenticated user requests a Service Ticket (ST) to access a service by sending their TGT and the target service's Service Principal Name (SPN) to the Ticket Granting Service (TGS).
	- **TGS-REP:** The TGS returns a ST encrypted with the target service account's NTLM hash if the TGT is valid and if the requesting user has permissions to access the target service.
3. **Accessing a Service**
	- **AP-REQ:** Authenticated user requests access to the target service by providing it the ST.
	- **AP-REP:** Target service allows access if the ST is successfully decrypted using the service account's NTLM hash.

## Protocol Breakdown
---
### Visual Diagram

![[Pasted image 20231015203512.png]]

### TGT Requests/Responses

##### AS-REQ (w/ PREAUTH):
- Request for a Ticket-Granting-Ticket (TGT), containing the user's User Principal Name (UPN) and a timestamp that is encrypted with the client's key (aka user's NTLM hash).
	- Sent from Client to Authentication Service (AS)
	- The encrypted timestamp is PREAUTH portion.
	- **Shared Key:**
		- **Key:** the user's NTLM hash
		- **Shared Between:** Client and the Authentication Service (AS)

##### AS-REP (w/ PREAUTH):
- A Ticket-Granting-Ticket (TGT) is returned that is encrypted with the KRBTGT hash and signed with the client's key IF the PREAUTH is validated.
	- Sent from Authentication Service (AS) to Client
	- A TGT is returned after validation is done, by decrypting the timestamp with the NTLM hash stored in the Kerberos Database (AD) for that specific UPN.
	- **Shared Key:**
		- **Key:** the KRBTGT NTLM hash
		- **Shared Between:** AS and the Ticket-Granting-Service (TGS)

##### AS-REQ (w/o PREAUTH):
- Request for a Ticket-Granting-Ticket (TGT), containing only the user's User Principal Name (UPN).
	- Sent from Client to Authentication Service (AS)
	- **Shared Key:**
		- **Key:** n/a
		- **Shared Between:** n/a

##### AS-REP (w/o PREAUTH):
- A Ticket-Granting-Ticket (TGT) is returned that is encrypted with the KRBTGT hash and signed with the client's key WITHOUT validating any PREAUTH.
	- Sent from Authentication Service (AS) to Client
	- A TGT is returned for that specific UPN without authentication.
	- **Shared Key:**
		- **Key:** the KRBTGT NTLM hash
		- **Shared Between:** AS and the Ticket-Granting-Service (TGS)

### TGS Requests/Responses

##### TGS-REQ
- TBD

##### TGS-REP
- TBD
## Pre-Authentication
---

**Example Authentication for a Client to access a Network File Service**

![[Pasted image 20230824195249.png]]

**(1) AS-REQ:**
- Client sends authentication request to Authentication Service (AS), which is partially encrypted with their password used as the secret key.

![[Pasted image 20230824194533.png]]

**(2) AS-REP:**
- Authentication Service (AS) verifies client authentication by referencing the Kerberos Database for the the requested user's secret key.  If that secret key exists in the Kerberos Database and successfully decrypts the authentication request, the AS returns a Ticket-Granting-Ticket (TGT)  which is encrypted with a key shared between the AS and the Ticket-Granting-Service (TGS).

![[Pasted image 20230824194643.png]]

**(3)  TGS-REQ:**
- TBA