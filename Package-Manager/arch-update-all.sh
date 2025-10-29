#!/bin/bash

# This script updates all packages on an Arch-based system
# Updates with pacman, AUR helper (yay or paru), flatpak, and snap

set -e

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Update system packages with pacman
update_pacman() {
    echo -e "${GREEN}Updating system packages with pacman...${RESET}"
    sudo pacman -Syu --noconfirm
    echo -e "${GREEN}Removing unneeded dependencies...${RESET}"
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || echo -e "${YELLOW}No unneeded packages to remove.${RESET}"
}

# Detect and update AUR packages with the AUR helper
update_aur() {
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    else
        echo -e "${YELLOW}No AUR helper (yay/paru) found. Skipping AUR updates.${RESET}"
        return
    fi

    echo -e "${GREEN}Updating AUR packages with $AUR_HELPER...${RESET}"
    $AUR_HELPER -Syu --noconfirm
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
        sudo snap refresh
    else
        echo -e "${YELLOW}Snap not installed, skipping.${RESET}"
    fi
}

# Main execution
echo -e "${YELLOW}Starting full system update...${RESET}"
update_pacman && echo
update_aur && echo
update_flatpak && echo
update_snap && echo
echo -e "${GREEN}✅ All updates completed successfully!${RESET}"
