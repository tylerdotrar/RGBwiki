
### Overview
---

Often times we want to switch to HTTPS for web services that we input sensitive information into, or to simply make our homelab services look and feel robust.  While invalid certificates still provide encryption and accomplish the first goal of sensitive information encryption, they sure do look ugly.

![[Pasted image 20230824142052.png]]

An easy method of achieving this superficial goal is by using OPNsense as an internal Certificate Authority (CA) and generating internal server certificates for our hosted services.

### Internal Certificate Authorities (CA's)
---

Within OPNsense, go to ``System > Trust > Authorities``.  From here, we will create an internal Certificate Authority (Root CA) and an intermediate Certificate Authority (Intermediate CA).
- You only need a root CA for your services to properly work over HTTPS, but adding the intermediate is more secure and is a better security practice.

**Example Root CA:**
```
Descriptive Name:               <domain> Root CA
Method:                         'Create an internal Certificate Authority'
Lifetime (days):                3650 (ten years)
Distinguished Name:             <arbitrary_data>
Common Name:                    <domain>.ca
```

**Example Intermediate CA:**
```
Descriptive Name:               <domain> Intermediate CA
Method:                         'Create an intermediate Certificate Authority'
Signing Certificate Authority:  <domain> Root CA
Lifetime (days):                3650 (ten years)
Distinguished Name:             <arbitrary_data>
Common Name:                    opnsense.<domain>.ca
```


![[Pasted image 20230824133614.png]]

Once your certificate authorities are created, download both of your CA certificates and CA private keys.  We will need to import these into our system and/or browser to authenticate the certificates that our services will later provide.

![[Pasted image 20230824135520.png]]

One method to import these certificates is to go to your Brower's settings and search for "certificates".  From there, ``Manage Device Certificates --> Trusted Root Certification Authorities / Intermediate Certification Authorities --> Import...``

![[Pasted image 20230824142649.png]]

Once your Certificate Authorities have been imported, you can save the certificates and keys to a safe location and remove the Root CA. 
- It is a best practice for the Root CA to remain offline and for the intermediate certificate to be used to issue certificates.

### Internal Service Certificates
---

Next we create the server certificate for our desired internal service. Go to ``System --> Trust --> Certificates`` and click the the drop down. 

![[Pasted image 20230824145747.png]]

And fill out the information like so.

Example Server Certificate:
```
Method:                 'Create an inteneral Certificate'
Descriptive Name:       <service_name> Certificate
Certificate Authority:  <domain> Intermediate CA
Type:                   'Server Certificate'
Lifetime (days):        3650 (10 years)
Distinguished Name:     <arbitrary_data>
Common Name:            <service_name>.<domain>
Alternative Names:      DNS:  <dns_record>
                        IP:   <ip_address>
                        URI:  https://<dns_record>:<port>
```

![[Pasted image 20230824145658.png]]

Once you have your internal certificate created, export both your cert and key to move to your intended server and configure accordingly.

![[Pasted image 20230828115508.png]]

