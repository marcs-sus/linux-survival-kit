#!/bin/bash

# This script updates all packages on a Debian-based system
# Updates system packages (apt/nala/aptitude), Flatpak, and Snap packages

set -e

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Detect available apt frontend
APT_CMD=""
if command -v nala >/dev/null 2>&1; then
    APT_CMD="nala"
elif command -v aptitude >/dev/null 2>&1; then
    APT_CMD="aptitude"
elif command -v apt >/dev/null 2>&1; then
    APT_CMD="apt"
else
    echo -e "${RED}No supported package manager found (apt/nala/aptitude).${RESET}"
    exit 1
fi

# Update system packages with apt or its frontend
update_apt() {
    echo -e "${GREEN}Updating system packages with ${APT_CMD}...${RESET}"
    sudo $APT_CMD update && sudo $APT_CMD upgrade -y && sudo $APT_CMD autoremove -y
}

# Update Flatpak packages if installed
update_flatpak() {
    if command -v flatpak >/dev/null 2>&1; then
        echo -e "${GREEN}Updating Flatpak apps...${RESET}"
        flatpak --user update -y
        sudo flatpak --system update -y
        flatpak --user uninstall --unused
        sudo flatpak --system uninstall --unused
    else
        echo -e "${YELLOW}Flatpak not installed, skipping.${RESET}"
    fi
}

# Main execution
echo -e "${YELLOW}Starting full system update...${RESET}"
update_apt && echo
update_flatpak && echo
echo -e "${GREEN}✅ All updates completed successfully!${RESET}"
