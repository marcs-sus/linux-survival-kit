#!/bin/bash

# This script updates all packages on a Debian-based system
# Updates system packages (apt/nala/aptitude), Flatpak, and Snap packages

set -e

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Relaunch as root if not already
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}Not running as root, re-executing with sudo...${RESET}"
    exec sudo "$0" "$@"
fi

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
    $APT_CMD update
    $APT_CMD upgrade -y
    $APT_CMD autoremove -y
}

# Update Flatpak packages if installed
update_flatpak() {
    if command -v flatpak >/dev/null 2>&1; then
    	echo -e "${GREEN}Updating Flatpak apps...${RESET}"
        flatpak update -y
    else
        echo -e "${YELLOW}Flatpak not installed, skipping.${RESET}"
    fi
}

# Update Snap packages if Snap is installed
update_snap() {
    if command -v snap >/dev/null 2>&1; then
        echo -e "${GREEN}Updating Snap packages...${RESET}"
        snap refresh
    else
        echo -e "${YELLOW}Snap not installed, skipping.${RESET}"
    fi
}

# Main execution
echo -e "${YELLOW}Starting full system update...${RESET}"
update_apt && echo
update_flatpak && echo
update_snap && echo
echo -e "${GREEN}✅ All updates completed successfully!${RESET}"
