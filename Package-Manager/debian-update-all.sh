#!/bin/bash

# This script updates all packages on a Debian-based system
# Updates with apt, flatpak, and snaps

set -e

# Relaunch as root if not already
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[1;33mNot running as root, re-executing with sudo...\033[0m"
    exec sudo "$0" "$@"
fi

# Check if any apt frontend is installed
APT_CMD=""

if which nala > /dev/null; then
    APT_CMD="nala"
elif which aptitude > /dev/null; then
    APT_CMD="aptitude"
elif which apt > /dev/null; then
    APT_CMD="apt"
else
	echo -e "\033[1;31mYour system does not have the apt package manager.\033[0m"
	exit 1
fi

# Update system packages with apt or its frontend
update_apt() {
	echo -e "\033[1;32mUpdating system packages with $APT_CMD...\033[0m"
	$APT_CMD update
	$APT_CMD upgrade -y
	$APT_CMD autoremove -y
}

# Update Flatpak packages if Flatpak is installed
update_flatpak() {
	if which flatpak > /dev/null; then
		echo -e "\033[1;32mUpdating Flatpak apps...\033[0m"	
		flatpak update -y
	else
		echo -e "\033[1;31mFlatpak not installed. Skipping Flatpak updates.\033[0m"
	fi
}

# Update Snap packages if Snap is installed
update_snap() {
	if which snap > /dev/null; then
		echo -e "\033[1;32mUpdating Snap packages...\033[0m"
		snap refresh
	else
		echo -e "\033[1;31mSnap not installed. Skipping Snap updates.\033[0m"
	fi
}

# Main function to run all updates
main() {
	update_apt
	echo
	update_flatpak
	echo
	update_snap
}

# Call the main function
main
