#!/bin/bash

# Script to configure UFW (Uncomplicated Firewall) on a Linux system
# Set default policies and allow essential services

# Check if ufw is installed
if ! command -v ufw &> /dev/null; then
	echo -e "\033[1;31mufw is not installed. Installing it now...\033[0m"

    sudo apt update
    sudo apt install ufw
else
    echo -e "\033[1;32mufw is already installed. Attempting to update it now...\033[0m"

    sudo apt update
    sudo apt upgrade ufw -y 
fi

# Set default policies
echo -e "\033[1;34mSetting default UFW policies...\033[0m"

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw logging low

echo -e "\033[1;34mEnabling UFW...\033[0m"

sudo ufw enable