#!/bin/bash

# This script installs Google Chrome on a Debian-based system.
# It adds the Google Chrome repository, imports the signing key, and installs the stable version.

set -e

# Require root privileges
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31mThis script must be run as root (use sudo).\033[0m"
   exit 1
fi

# Check if Chrome is already installed
if command -v google-chrome &> /dev/null; then
    echo -e "\033[1;32mGoogle Chrome is already installed. Exiting.\033[0m"
    exit 0
fi

# Check for wget and gpg, install if missing
missing_pkgs=()
if ! command -v wget &> /dev/null; then
    missing_pkgs+=(wget)
fi
if ! command -v gpg &> /dev/null; then
    missing_pkgs+=(gnupg)
fi
if (( ${#missing_pkgs[@]} )); then
    echo -e "\033[1;33mInstalling missing packages: ${missing_pkgs[*]}...\033[0m"
    apt update -qq
    apt install -y "${missing_pkgs[@]}"
fi

# Define architecture of the system
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" != "amd64" ]]; then
    echo -e "\033[1;31mWarning: Architecture is $ARCH, but Google Chrome repo is amd64-only. Proceeding may cause issues.\033[0m"
    read -p "Do you want to proceed with the installation (y/N)? " -n 1 answer
    case $answer in
        y|Y)
            ;;
        *)
            echo "Aborting installation."
            exit 0
            ;;
    esac
fi

# Download and dearmor the signing key
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome.gpg

# Add the repository in modern deb822 format (use https)
cat > /etc/apt/sources.list.d/google-chrome.sources << EOF
Types: deb
URIs: https://dl.google.com/linux/chrome/deb/
Suites: stable
Components: main
Architectures: $ARCH
Signed-By: /usr/share/keyrings/google-chrome.gpg
EOF

# Update package lists
apt update

# Install Chrome Stable
apt install -y google-chrome-stable

echo -e "\033[1;32m\033[1mGoogle Chrome installed successfully!\033[0m"