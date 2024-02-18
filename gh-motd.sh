#!/usr/bin/env bash

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
echo -e "\n→ Installing ansiweather, lolcat, and sysvbanner"
sudo apt-get update &>/dev/null
sudo apt-get install ansiweather lolcat sysvbanner figlet -y &>/dev/null
echo -e "\n→ Downloading MOTD config template"
sudo rm /etc/update-motd.d/00-welcome &>/dev/null
sudo wget https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-welcome &>/dev/null
sudo mv 00-welcome /etc/update-motd.d/ &>/dev/null
sudo chmod -x /etc/update-motd.d/* &>/dev/null
sudo chmod +x /etc/update-motd.d/00-welcome &>/dev/null
echo -e "\n→ MOTD Customization finished ←\n"
echo -e "PS: To update the weather location, change this file: \"/etc/update-motd.d/00-welcome\""
echo -e "\n"
