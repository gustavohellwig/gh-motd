#!/usr/bin/env bash

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
echo -e "\n---Installing ansiweather, lolcat, and sysvbanner"
sudo apt-get update &> /dev/null && sudo apt-get install ansiweather lolcat sysvbanner figlet -y &> /dev/null
echo -e "\n---Downloading MOTD Config"
sudo wget https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-welcome -P /etc/update-motd.d/ &> /dev/null && sudo chmod +x /etc/update-motd.d/00-welcome &> /dev/null
sudo chmod -x /etc/update-motd.d/* && sudo chmod +x /etc/update-motd.d/00-welcome &> /dev/null
echo -e "\n---MOTD Finished\n"
echo -e "\nUpdate the file /etc/update-motd.d/00-welcome according the location that you want to show the weather forecast"
echo -e "\n---MOTD---\n"
