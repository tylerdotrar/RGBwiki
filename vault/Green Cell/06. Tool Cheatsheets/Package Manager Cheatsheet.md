
## Overview
---
**CLI Package Managers** are tools that facilitate the installation, removal, and management of software packages on a system through the command line. These package managers streamline the process of handling dependencies, ensuring software compatibility, and automating updates. Users can use these tools to search for, install, and manage software packages efficiently, making it easier to maintain a well-configured and up-to-date system while avoiding the complexities of manual installations and dependency resolution. 

Example Package Managers:
- **apt** for Debian-based Linux distributions
- **pacman** for Arch Linux (with **yay** as an AUR helper)
- **winget** for Windows

## apt
---

`apt` is the default package manager for Debian-based Linux distributions, handling tasks like installation, removal, and system updates by installing pre-compiled binaries from official repositories. It ensures software compatibility, manages dependencies, and provides commands for package search, updates, and system upgrades.

Other tools, such as `apt-get` and `aptitude`, share similar syntax and functionality, allowing users to interchangeably manage packages on Debian-based systems.

```shell
# Update Package Lists & Upgrade all Packages (Force)
sudo apt update && sudo apt upgrade -y

# Full Upgrade System (will remove packages if necessary for upgrade)
sudo apt full-upgrade

# Remove Old / Deprecated Dependencies
sudo apt autoremove

# Search for Packages
sudo apt search <package_name>

# Install a Package
sudo apt install <package_name> -y

# Remove Package
sudo apt remove <package_name>
```

## pacman / yay
---

`pacman` is the primary package manager for Arch Linux that installs pre-compiled binaries from official repositories, whereas `yay` is a wrapper for it that can also install packages from the unofficial AUR (Arch User Repository).

`yay` syntax is mostly identical to `pacman`, so the following switches `pacman` switches should work identically with `yay`.  Variations will be notated.

```shell
# Update Package Lists (-Syy) & Upgrade all Packages (-Syu)
sudo pacman -Syyu
sudo yay

# Search for package or packages in the repositories 
pacman -Ss <package_name>     
yay <package_name>

# Return detailed information about a specific package
pacman -Si <package_name>

# Install a Package (or upgrade existing package)
sudo pacman -S <package_name>

# Install a Package (downloaded locally)
sudo pacman -U  <package_name>.pkg.tar.xz

# Remove package (but retain its configuration and deps)
sudo pacman -R  <package_name>

# Remove package, its configuration and all unwanted dependencies 
sudo pacman -Rns <package_name>

# Remove Orphaned Packages
sudo pacman -Rns $(pacman -Qdtq)
sudo yay -Qtd 

# Clean up Package Cache
sudo pacman -Sc
```

## winget
---

`winget` is the native package manager for Windows, inspired by Linux package managers. It installs applications from the Microsoft Store and other supported sources, providing a streamlined process for users to maintain and update their software. Its straightforward syntax and integration with Windows make it an efficient tool for managing applications on the Microsoft operating system.

```powershell
# Search for Packages
winget search "<package_name>"

# Install Package via Name
winget install "<package_name>"

# Install Package via ID (unique)
winget install --id <package.id>

# Remove Package
winget uninstall "<package_name>"

# List all Installed Packages
winget list

# List all Packages w/ Available Update
winget upgrade

# Upgrade Package
winget upgrade "<package_name>"
```
