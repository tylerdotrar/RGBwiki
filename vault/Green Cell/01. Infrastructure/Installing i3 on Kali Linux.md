
### Installation via CleanBuilds
---

**My [CleanBuilds](https://github.com/tylerdotrar/CleanBuilds) repository can be found here.**

```shell
git clone https://github.com/tylerdotrar/CleanBuilds
cd CleanBuilds/kali-i3
chmod +x build.sh
./build.sh
```

![[Pasted image 20231015213833.png]]

### Installation via Kali-i3-Endeavour
---

**Mesumine's [kali-i3-endeavour](https://github.com/mesumine/kali-i3-endeavour)repository can be found here.**

```shell
git clone https://github.com/Mesumine/kali-i3-endeavour.git 
cd kali-i3-endeavour 
chmod +x install.sh 
```

- Usage:
```
Usage:
'./install.sh -a'		 to install all optional programs, aimed at full installation
'./install.sh -m -v' 		 to install only required programs, aimed at Virtual machine
'./install.sh -c list.txt -v -b'	 to install optional programs from list, aimed at VM, with Alt as bind key

 -a             Install and configure all optional packages.
 -m             Install and configure only the required packages.
 -b             Change bind key from Windows to Alt.
 -c <list.txt>  Install and configure the packages in the list in addition to the required packages.
 -v             Configure towards VM. change $mod+g to $mod+Shift+g. change $mod+l to $mod+Shift+l
 -h             Print help.

The optional programs are:
Flameshot:	 a screen capture tool that can grab sections of the screen and edit on the fly.
neovim:	     hyperextensible Vim-based editor. Also comes with custom config file.
picom:	     a lightweight compositor for x11. Will be used for transparent terminals
arandr:	     gui interface for xrandr. used for changing display settings

```

![[Pasted image 20231015213948.png]]


