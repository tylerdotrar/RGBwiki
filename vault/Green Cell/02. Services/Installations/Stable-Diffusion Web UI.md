
Recommended Resources for CPU:
- at least 4 cores, 4GB memory, 30GB

```bash
# Updates & Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install wget git python3 python3-venv libgl1 libglib2.0-0 libgoogle-perftools4 libtcmalloc-minimal4 -y

# Non-Root User Requirements
mkdir /var/www/stable-diffusion --parents
useradd -d /var/www/stable-diffusion webui
su webui
cd ~

# Installation
wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
chmod +x webui.sh

# No GPU
./webui.sh --use-cpu all --precision full --no-half --skip-torch-cuda-test --listen --port 8080

# Sampling Method: LMS
# Sampling Steps: 40
# CFG Scale: 8
# Completion Time: ~ 3 mins

# Sampling Method: DPM++ 2M Karras
# Sampling Steps: 25
# CFG Scale: 10
# Completion Time: ~ 2 mins
```