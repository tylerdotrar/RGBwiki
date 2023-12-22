
### Overview
---
**i3** is a Linux window tiling manager; effectively a Linux desktop environment that's stripped down to its absolute minimum. While appearing to be counterintuitive, it's targeted at developers and enthusiast users to optimize speed and efficiency.  Similar to `vim`, familiarity with a tiling manager can improve productivity and workflow speeds.

Installing i3 on Kali Linux is a little more involved than other, more barebones distributions.  Because of that, some installation scripts can be utilized.

### Installation via CleanBuilds
---
> [!info]
> My **CleanBuilds** repository can be found [here](https://github.com/tylerdotrar/CleanBuilds).

```shell
# Installation
git clone https://github.com/tylerdotrar/CleanBuilds
cd CleanBuilds/kali-i3
chmod +x build.sh

# Script Usage
./build.sh
```

![[Pasted image 20231015213833.png]]

### Installation via Kali-i3-Endeavour
---
> [!info]
> Mesumine's **kali-i3-endeavour** repository can be found [here](https://github.com/mesumine/kali-i3-endeavour).


```shell
# Installation
git clone https://github.com/Mesumine/kali-i3-endeavour.git 
cd kali-i3-endeavour 
chmod +x install.sh

# Script Usage
'./install.sh -a'		          to install all optional programs, aimed at full installation
'./install.sh -m -v' 		      to install only required programs, aimed at Virtual machine
'./install.sh -c list.txt -v -b'  to install optional programs from list, aimed at VM, with Alt as bind key

 -a             Install and configure all optional packages.
 -m             Install and configure only the required packages.
 -b             Change bind key from Windows to Alt.
 -c <list.txt>  Install and configure the packages in the list in addition to the required packages.
 -v             Configure towards VM. change $mod+g to $mod+Shift+g. change $mod+l to $mod+Shift+l
 -h             Print help.

The optional programs are:
Flameshot :	 a screen capture tool that can grab sections of the screen and edit on the fly.
neovim    :  hyperextensible Vim-based editor. Also comes with custom config file.
picom     :	 a lightweight compositor for x11. Will be used for transparent terminals
arandr    :  gui interface for xrandr. used for changing display settings
```


![[Pasted image 20231015213948.png]]


