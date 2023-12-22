
### Overview
---
Metasploitable2 is an intentionally vulnerable Ubuntu Linux virtual machine that is designed for testing common vulnerabilities.  It allows for a secure and free way to perform penetration testing and security research on a local target.  By default, this virtual machine (VM) is compatible with VMWare, VirtualBox, and other common virtualization platforms.

By default, the VM is not compatible with Proxmox because it is a `.vmdk` image.  Luckily, Proxmox has some utilities that can be used to convert the `.vmdk` image to a working `.qcow2` image.

### Installation
---

The following installation should be done from your Proxmox node's terminal, and the only dependency should be `unzip`.

```shell
# Variables (change accordingly)
vm_id="<target_vm_id>"
vm_name="Metasploitable2"
vm_bridge="vmbr0"
vm_bootdisk="ide0"
storage_volume="local"

# Download and unzip Metasploitable2 Image
wget https://sourceforge.net/projects/metasploitable/files/Metasploitable2/metasploitable-linux-2.0.0.zip
unzip metasploitable-linux-2.0.0.zip
cd Metasploitable2-Linux/

# Create a new qcow2 storage disk
qemu-img convert -O qcow2 Metasploitable.vmdk metasploitable.qcow2

# Create a new VM using qcow2 storage disk
qm create $vm_id --memory 2048 --cores 2 --name $vm_name --net0 virtio,bridge=${vm_bridge} --boot c --bootdisk $vm_bootdisk

# Import qcow storage disk to target storage volume
qm importdisk $vm_id metasploitable.qcow2 $storage_volume

# Set VM's storage disk to the imported disk
# - Note: snapshots won't work because the storage is '.raw'
qm set $vm_id --ide0 local:${vm_id}/vm-${vm_id}-disk-0.raw
```
