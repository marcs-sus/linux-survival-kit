#!/bin/bash

# This script manages firmware updates using fwupd.
# Uses a basic flow of fwupd commands to check for and apply firmware updates.

set -e

# Relaunch as root if not already
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[1;33mNot running as root, re-executing with sudo...\033[0m"
    exec sudo "$0" "$@"
fi

# Check if fwupd is installed
if ! command -v fwupdmgr &>/dev/null; then
    echo -e "\033[1;31fwupd is not installed. Please install it first.\033[0m"
    echo -e "\033[1;31mYou can install it using: sudo apt install fwupd\033[0m"
    exit 1
fi

# Basic fwupd command usage flow
fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
