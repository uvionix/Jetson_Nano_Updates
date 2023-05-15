#!/bin/bash

echo "*** Applying patch-001-15-May-2023 - Vehicle mode change via socket connection. Support for multiple wifi networks upon autoconnect ***"

# Get the logged-in username
usr=$(logname)

# Create the download directory
mkdir -p /home/$usr/Repos
cd /home/$usr/Repos

# Clone the new repositories
echo "Cloning repositories..."
repoexists=$(ls | grep "Jetson_Nano_Linux_Services")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Linux_Services
fi

repoexists=$(ls | grep "Jetson_Nano_Shell_Scripts")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Shell_Scripts
fi

repoexists=$(ls | grep "Jetson_Nano_Python_Scripts")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Python_Scripts
fi

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git
git clone https://github.com/sdarmonski/Jetson_Nano_Shell_Scripts.git
git clone https://github.com/sdarmonski/Jetson_Nano_Python_Scripts.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/switch-to-rtl.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/chmod_offline.py /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/update-uav-status.py /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/uvx_ipc_api.py /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/mavproxy-setup /etc/default/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/mavproxy-autostart.service /etc/systemd/system/

sed -i 's/%u/'"$usr"'/gi' /etc/systemd/system/mavproxy-autostart.service

echo "Modify file permissions..."
chmod +x /usr/local/bin/network-watchdog.sh
chmod +x /usr/local/bin/switch-to-rtl.sh
chmod +x /usr/local/bin/chmod_offline.py
chmod +x /usr/local/bin/update-uav-status.py
chmod +x /usr/local/bin/uvx_ipc_api.py

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts
rm -d -r Jetson_Nano_Python_Scripts

echo "Update successful!"
