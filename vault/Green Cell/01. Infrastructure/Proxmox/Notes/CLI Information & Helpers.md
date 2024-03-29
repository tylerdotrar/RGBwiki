
### Key File Locations
---
Configuration files for LXC's:
- ``/etc/pve/nodes/<node_name>/lxc/<id>.conf``

Configuration files for VM's:
- ``/etc/pve/qemu-server/<id>.conf``

### Starting/Stopping from the CLI
---

```shell
# Interacting with existing VMs
qm list                  # List all virtual machines
qm start <vmid>          # Start VM
qm reboot <vmid>         # Reboot VM (shutdown, start)
qm shutdown <vmid>       # Gracefully stop VM (send poweroff)
qm stop <vmid>           # Kill VM (immediate stop)
qm reset <vmid>          # Reset VM (stop, start)
qm suspend <vmid>        # Suspend VM
qm resume <vmid>         # Resume VM

qm destroy <vmid>        # Destroy VM (delete all files)


# Interacting with existing LXCs
pct list                 # List all LXC's
pct start <vmid>         # Start LXC
pct reboot <vmid>        # Reboot LXC (shutdown, start)
pct shutdown <vmid>      # Gracefully stop LXC (send poweroff)
pct stop <vmid>          # Kill LXC (immediate stop)
pct suspend <vmid>       # Suspend LXC
pct resume <vmid>        # Resume LXC

pct clone <vmid> <newid> # Copy LXC
pct destroy <vmid>       # Destroy LXC (delete all files)
```

### Useful Scripts
---

- `lsiommu.sh` - List IOMMU groups with correlated devices.

```shell
#!/usr/bin/env bash

# Requires: lspci, lsusb
shopt -s nullglob
lastgroup=""
for g in `find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V`; do
    for d in $g/devices/*; do
        if [ "${g##*/}" != "$lastgroup" ]; then
            echo -en "Group ${g##*/}:\t"
        else
            echo -en "\t\t"
        fi
        lastgroup=${g##*/}
        lspci -nms ${d##*/} | awk -F'"' '{printf "[%s:%s]", $4, $6}'
        if [[ -e "$d"/reset ]]; then echo -en " [R] "; else echo -en "     "; fi

        lspci -mms ${d##*/} | awk -F'"' '{printf "%s %-40s %s\n", $1, $2, $6}'
        for u in ${d}/usb*/; do
            bus=$(cat "${u}/busnum")
            lsusb -s $bus: | \
                awk '{gsub(/:/,"",$4); printf "%s|%s %s %s %s|", $6, $1, $2, $3, $4; for(i=7;i<=NF;i++){printf "%s ", $i}; printf "\n"}' | \
                awk -F'|' '{printf "USB:\t\t[%s]\t\t %-40s %s\n", $1, $2, $3}'
        done
    done
done
```

- Example Output: 

| IOMMU Group | Vendor:Device | Reset | Device ID | Description | Device | 
| --- | --- | --- | --- | --- | --- |
| Group 24: | \[8086:24fd] | \[R] | 02:00.0 | Network controller | Wireless 8265 / 8275 |

You can then take the Device ID and feed it into ``lspci`` to get verbose information on that device.
```shell
# Return Very Verbose information on the Network Controller
lspci -s 02:00.0 -vv
```

Another interesting way to get this information is:
```shell
pvesh get /nodes/<node_name>/hardware/pci --pci-class-blacklist ""
```