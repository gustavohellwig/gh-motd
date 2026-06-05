#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "ERROR: Failed on line $LINENO"; exit 1' ERR

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
echo -e "\n→ Installing dependencies"
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y \
    lolcat \
    sysvbanner \
    figlet \
    wget >/dev/null 2>&1
#sudo apt-get install ansiweather
echo -e "\n→ Downloading MOTD config template"
#sudo rm /etc/update-motd.d/00-welcome &>/dev/null
#sudo wget https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-welcome &>/dev/null
sudo curl -fsSL -o /etc/update-motd.d/00-welcome https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-welcome
#sudo mv 00-welcome /etc/update-motd.d/ &>/dev/null
#sudo chmod -x /etc/update-motd.d/* &>/dev/null
sudo chmod +x /etc/update-motd.d/00-welcome &>/dev/null
#sudo find /etc/update-motd.d -maxdepth 1 -type f ! -name "00-welcome" -exec chmod -x {} \;
echo -e "\n→ MOTD Customization finished ←\n"
echo -e "PS: To update the weather location, change this file: \"/etc/update-motd.d/00-welcome\""
echo -e "\n"
