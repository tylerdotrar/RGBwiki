
### NTLM vs Net-NTLM (NTLMv2)
---

**NTLM (NTLMv1):**
- Stored in the SAM database and/or in the DC's NTDS.dit database.
- Looks like this:
```
aad3b435b51404eeaad3b435b51404ee:e19ccf75ee54e06b06a5907af13cef42
              LM                :             NT
```

**Net-NTLM (NTLMv2):**
- Net-NTLM hashes are used for network authentication (they are derived from a challenge/response algorithm and are based on the user's NT hash).
- Looks like this:
```
admin::N46iSNekpT:08ca45b7d7ea58ee:88dcbe4446168966a153a0064958dac6:5c7830315c7830310000000000000b45c67103d07d7b95acd12ffa11230e0000000052920b85f78d013c31cdb3b92f5d765c783030
```

**Pass-The-Hash:**
- You **CAN** perform Pass-The-Hash attacks with **NTLM** hashes.
- You **CANNOT** perform Pass-The-Hash attacks with **Net-NTLM** hashes. However, they can be used to perform relay attacks.