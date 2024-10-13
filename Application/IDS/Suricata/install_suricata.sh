#!/bin/bash
# Password
printf "password: "
read -s password

echo "$password" | sudo -S apt-get update && sudo -S apt-get -y upgrade
sudo -S apt install software-properties-common
sudo -S add-apt-repository -E ppa:oisf/suricata-stable
sudo -S apt-get update
sudo -S apt-get -y install suricata
