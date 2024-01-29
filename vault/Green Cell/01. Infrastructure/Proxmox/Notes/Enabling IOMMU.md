
>[!info]
>This will be beautified later.

Modify `/etc/default/grub`:
```shell
# Comment out
#GRUB_CMDLINE_LINUX_DEFAULT="quiet"

# For AMD, add:
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
# For Intel, add: 
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
```


Update grub.
```shell
update-grub
```

Add the following to `/etc/modules`:
```shell
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

Reboot the node.