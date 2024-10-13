#!/bin/bash
printf "password: "
read -s password

echo "$password" | sudo -S apt-get update && sudo -S apt -y upgrade

# Obtain Ubuntu version
VERSION=$(lsb_release -sr)

# Install zeek
echo "deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_$VERSION/ /" | sudo -S tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_$VERSION/Release.key | gpg --dearmor | sudo -S tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo -S apt update
sudo -S apt install -y zeek-lts

# Install spicy
wget https://github.com/zeek/spicy/releases/download/v1.11.2/spicy_linux_ubuntu22.deb
sudo -S dpkg -i spicy_linux_ubuntu22.deb
