#!/usr/bin/env bash

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
echo -e "\n---Installing ansiweather, lolcat, and sysvbanner"
sudo apt-get update
sudo apt-get install ansiweather lolcat sysvbanner figlet -y
echo -e "\n---Downloading MOTD Config"
sudo rm /etc/update-motd.d/00-welcome
sudo wget https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-welcome -P /etc/update-motd.d/
sudo chmod -x /etc/update-motd.d/*
sudo chmod +x /etc/update-motd.d/00-welcome
echo -e "\n---MOTD Finished---\n"
echo -e "Update this file \"/etc/update-motd.d/00-welcome\" according to the location where you want to show the weather forecast."
echo -e "\n"
