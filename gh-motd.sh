#!/usr/bin/env bash

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
sudo add-apt-repository ppa:dawidd0811/neofetch
sudo apt-get update && sudo apt-get install neofetch ansiweather lolcat sysvbanner -y &> /dev/null
cat <<EOF > /etc/update-motd.d/00-welcome
#!/bin/sh
echo
sysvbanner $(hostname -s) | /usr/games/lolcat -f
echo
#/usr/bin/neofetch --ascii_distro GNU
echo
/usr/bin/landscape-sysinfo
echo
stamp="/var/lib/update-notifier/updates-available"
[ ! -r "$stamp" ] || cat "$stamp"
find $stamp -newermt 'now-7 days' 2> /dev/null | grep -q -m 1 '.' || /usr/share/update-notifier/notify-updates-outdated
ansiweather -l Kijabe,KE -p false
ansiweather -l Kijabe,KE -p false -f 3
echo
EOF
sudo chmod -x /etc/update-motd.d/* && sudo chmod +x /etc/update-motd.d/00-welcome &> /dev/null
