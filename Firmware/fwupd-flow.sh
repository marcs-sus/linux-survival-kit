#!/bin/bash

# Check if fwupd is installed
if ! command -v fwupdmgr &> /dev/null; then
	echo -e "\033[1;31mfwupd is not installed. Installing it now...\033[0m"

    sudo apt update
    sudo apt install fwupd
else
    echo -e "\033[1;32mfwupd is already installed. Attempting to update it now...\033[0m"

    sudo apt update
    sudo apt upgrade fwupd -y
fi

# Basic fwupd command usage flow
sudo fwupdmgr get-devices
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
