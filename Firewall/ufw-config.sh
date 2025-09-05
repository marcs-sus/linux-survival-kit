#!/bin/bash
# Script to configure UFW (Uncomplicated Firewall) on a Linux system

sudo apt update
sudo apt install ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

sudo ufw logging low

sudo ufw enable