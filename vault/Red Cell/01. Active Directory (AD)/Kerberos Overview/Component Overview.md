
>[!info]
>This note is still in development.
## Key Distribution Center
---
- The **Key Distribution Center (KDC)** is the primary component for authentication within Active Directory, and is generally running on Domain Controller(s) as part of **Active Directory Domain Services (AD DS)**.
- The KDC contains the following components:
	- **Authentication Service (AS)**
	- **Ticket Granting Service (TGS)**
	- **Kerberos Database (aka Active Directory)**

##### Authentication Service
- The **Authentication Service (AS)** is the primary service that handles initial user authentication and the distribution of Ticket-Granting-Tickets (TGT).
##### Ticket-Granting-Service
- The **Ticket-Granting-Service (TGS)**...

##### Kerberos Database
- The **Kerberos Database (aka Active Directory)**...

## Tickets
---
Kerberos works using a ticketing system for authentication rather than users supplying credentials for each service they want to access.  The ticketing system can be broken down into the following components:

##### Ticket-Granting-Ticket (TGT)

- Ticket granted Clients by the Authentication Service (AS) to authenticate them, and used to request Service Tickets from the Ticket Granting Service (TGS).
	- Ticket encrypted with a symmetric key (aka KRBTGT hash) only known between the Authentication Service (AS) and Ticket Granting Service (TGS).
	- Encrypted ticket is signed with Client's shared key (aka user's NTLM hash)

##### Service Ticket

- Ticket granted to authenticated Clients by the Ticket Granting Service (TGS) to allow access to Domain Services.
	- Requested with the authenticated client's Ticket-Granting-Ticket (TGT) and Service Principal Name (SPN) of the desired Domain Service.
	- Ticket is signed with the NTLM hash of the target Service Account.

##### Service Principal Name (SPN)

- Given to all Domain Service Accounts (e.g., IIS, MSSQL) to associate them with a login account.
	- When a user wants to access a service with an SPN, they receive a Kerberos Service Ticket signed with the NTLM password hash of the account running that service.
	- Any user with a valid TGT and permission to access the service can request a Service Ticket for any service with an SPN.