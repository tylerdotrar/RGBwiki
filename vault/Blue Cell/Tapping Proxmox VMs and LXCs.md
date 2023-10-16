
## Overview
---
This page will cover some simple TC scripts made to TAP VM/LXC network interfaces on Linux based hypervisors (e.g., Proxmox).  These scripts are also hosted on my [tc-taps](https://github.com/tylerdot/tc-taps) repository.

## Tutorial
---

Every VM/LXC has a network TAP interface based on their ID's and interface(s).

```
# Proxmox Virtual Machine Example
VM Example:      ID: 125 ; net0: vmbr0, net1: vmbr5
Network Tap(s):  tap125i0, tap125i1

# Proxmox LXC Example:
LXC Example:     ID: 203 ; net0: vmbr9
Network Tap(s):  veth203i0
```

You can search for these tap interfaces by running the following command on your Proxmox host:

```shell
# View available taps
ip --brief a | grep 'tap\|veth' | sed 's/@.*//g' | awk '{print $1}'
```

To tap these machines you will need to...

1. Create a virtual bridge to be used as a SPAN port (e.g., vmbr100).
    - ``Select Node --> System --> Network --> Create --> Linux Bridge``
    - Note: The SPAN port should have no IP, gateway, etc.
2. Add the created bridge to a SecurityOnion VM and use that bridge as the SPAN port.
3. Run the below "tc_up" script on the Proxmox host, specifying desired ID range to TAP and pointing to that created bridge.

```shell
#!/bin/bash

# Author: Tyler McCann (@tylerdotrar)
# Arbitrary Version Number: 1.1.1
# Link: https://github.com/tylerdotrar/tc-taps

# TAP any VM/LXC with an ID containing a specified value (e.g., 1001 - 1099 range).
ID_RANGE=10

# Virtual SPAN port to mirror traffic to.
SPAN_PORT='vmbr100'

# Add TAP(s) for above ID range to a 'network_taps' file.
ip --brief a | grep "tap\|veth" | sed 's/@.*//g' | grep $ID_RANGE | awk '{print $1}' > network_taps

###
#    *OR* you can manually include specific ID's.
#
#    echo tap<id_1>i0 > network_taps
#    echo veth<id_2>i0 >> network_taps
###

echo "Enabling TC Network TAP(s):"

# Read every TAP interface in 'network_taps' and forward traffic to the designated SPAN port
while read i;
do
    echo "- $i"

    # Capture Ingress Traffic
    tc qdisc add dev $i ingress
    tc filter add dev $i parent ffff: protocol all u32 match u8 0 0 action mirred egress mirror dev $SPAN_PORT

    # Capture Egress Traffic (thx @nukingdragons)
    tc qdisc add dev $i handle 1: root prio
    tc filter add dev $i parent 1: protocol all u32 match u8 0 0 action mirred egress mirror dev $SPAN_PORT
done < network_taps
```