
- This note is taken from my [ProxmoxMaster](https://github.com/tylerdotrar/ProxmoxMaster) repository.

```shell
#!/bin/bash

# AUTHOR: Tyler McCann (@tylerdotrar)
# ARBITRARY VERSION NUMBER: 1.0.0
# LINK: https://github.com/tylerdotrar/ProxmoxMaster


# Validate script is being ran with elevated privileges
if [ "$EUID" -ne 0 ]
  then echo "Script must be ran as root."
  exit
fi

# Visual formatting of output
print_yellow() {
  echo -e "$(tput setaf 3)$1$(tput setaf 7)"
}

# Target File(s)
sub_file='/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js'
sub_file_bak="${sub_file}.bak" # Backup of original file


### Step 1: Remove 'No valid subscription' message.
print_yellow "[+] Voiding 'No valid subscription' message from '$sub_file'..."

# Create backup of target file
cp $sub_file $sub_file_bak
print_yellow " o  Backup file created: '$sub_file_bak'"

# Get line number of unique string (- 1) and replace contents
line=$(grep -n 'No valid subscription' $sub_file | cut -f1 -d:)
line_p2=$((line - 1))
sed -i "${line_p2}c\\\t\t\t//Removed 'No valid subscription' message\n\t\t\tvoid({ //Ext.Msg.show({" $sub_file
print_yellow " o  Done.\n"


### Step 2: Restart PVE to take effect
print_yellow "[+] Restarting 'pveproxy' for changes to take effect..."
systemctl restart pveproxy
print_yellow " o  You will need to reload your page/clear your cache to see these changes (or open with a private window)."
print_yellow " o  Done.\n"
```