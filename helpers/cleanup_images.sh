#!/bin/bash

# Author: Tyler McCann (@tylerdotrar)
# Arbitrary Version Number: 1.0.0
# Link: https://github.com/tylerdotrar/RGBwiki


# Initialize flags as false
Verbose=false
Remove=false

# Initialize the directory paths
Attachments="../vault/attachments"
VaultRoot="../vault"

# Process command-line arguments as switches
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--verbose)
      Verbose=true
      ;;
    -r|--remove)
      Remove=true
      ;;
    --attachments)
      shift
      Attachments=$1
      ;;
    --vault)
      shift
      VaultRoot=$1
      ;;
    *)
      echo "Usage:  cleanup_images.sh"
      echo "  -v, --verbose      Print filenames of unique files."
      echo "  -r, --remove       Remove unique files in the 'attachments' directory."
      echo "      --attachments  Directory containing the vault's attachments."
      echo "      --vault        The root directory of the Obsidian vault."
      exit 1
      ;;
  esac
  shift
done

# Acquire a list of all available images and .md files
AvailableImages=($(find "$Attachments" -maxdepth 1 -type f -exec basename {} \;))
MdFiles=($(find "$VaultRoot" -type f -name "*.md"))

# Initialize arrays
UsedImages=()
UnusedImages=()
UnavailableImages=()

# Iterate through every .md file for attachments (RoamLinks)
for MdFile in "${MdFiles[@]}"; do
    while read -r line; do
        if [[ $line =~ \!\[\[([A-Za-z0-9\s.]+)\]\] ]]; then
            UsedImages+=("${BASH_REMATCH[1]}")
        fi
    done < "$MdFile"
done

# Remove duplicate entries
AvailableImages=($(echo "${AvailableImages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
UsedImages=($(echo "${UsedImages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Find unused and unavailable images
for image in "${AvailableImages[@]}"; do
    if [[ ! " ${UsedImages[@]} " =~ " $image " ]]; then
        UnusedImages+=("$image")
    fi
done
for image in "${UsedImages[@]}"; do
    if [[ ! " ${AvailableImages[@]} " =~ " $image " ]]; then
        UnavailableImages+=("$image")
    fi
done

# Function to print images
print_images() {
  local images_array=("$@")
  for image in "${images_array[@]}"; do
    echo " -  $image"
  done
}

# Print the differences based on the verbose flag
echo "[+] Total available images: ${#AvailableImages[@]}"
echo " o  Unused images: ${#UnusedImages[@]}"
if [[ $Verbose == true && ${#UnusedImages[@]} -gt 0 ]]; then
    print_images "${UnusedImages[@]}"
fi

echo -e "\n[+] Total used images: ${#UsedImages[@]}"
echo " o  Unavailable images: ${#UnavailableImages[@]}"
if [[ $Verbose == true && ${#UnavailableImages[@]} -gt 0 ]]; then
    print_images "${UnavailableImages[@]}"
fi

# Remove unused images from the 'attachments' directory based on the remove flag
if [[ $Remove == true && ${#UnusedImages[@]} -gt 0 ]]; then
    echo -e "\n[+] Removing unused image(s)..."
    for image in "${UnusedImages[@]}"; do
        rm -f "$Attachments/$image"
    done
    echo " o  Done."
elif [[ ${#UnusedImages[@]} -lt 1 ]]; then
    echo -e "\n[-] No unused image(s) to delete."
fi
