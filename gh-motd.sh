#!/usr/bin/env bash

#--------------------------------------------------
# MOTD Configurations
#--------------------------------------------------
echo -e "\nMOTD Configurations"
echo -e "\n---Installing ansiweather, lolcat, and sysvbanner"
sudo apt-get update && sudo apt-get install ansiweather lolcat sysvbanner -y &> /dev/null
echo -e "\n---Creating MOTD Config"
sudo bash -c 'cat <<EOF > /etc/update-motd.d/00-welcome
#!/bin/sh
echo
sysvbanner "$(hostname -s)" | /usr/games/lolcat -f
echo
/usr/bin/landscape-sysinfo
echo
stamp="/var/lib/update-notifier/updates-available"
[ ! -r "$(stamp)" ] || cat "$(stamp)"
find $(stamp) -newermt "now-7 days"" 2> /dev/null | grep -q -m 1 "." || /usr/share/update-notifier/notify-updates-outdated
ansiweather -l Kijabe,KE -p false
ansiweather -l Kijabe,KE -p false -f 3
echo
EOF'
sudo chmod -x /etc/update-motd.d/* && sudo chmod +x /etc/update-motd.d/00-welcome &> /dev/null
echo -e "\n---MOTD Finished\n"
