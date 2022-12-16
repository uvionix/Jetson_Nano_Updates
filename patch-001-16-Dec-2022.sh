#!/bin/bash

echo "*** Applying patch-001-16-Dec-2022 - Adding UAV status update service ***"

# Get the logged-in username
usr=$(logname)

# Create the download directory
mkdir /home/$usr/uvx
mkdir /home/$usr/Repos
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
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/uvx-update-checker.sh /home/$usr/uvx/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/update-uav-latest-status.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/update-uav-status.py /usr/local/bin/

echo "Modify file permissions..."
chmod +x /usr/local/bin/network-watchdog.sh
chmod +x /usr/local/bin/update-uav-status.py
chmod +x /home/$usr/uvx/uvx-update-checker.sh

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts
rm -d -r Jetson_Nano_Python_Scripts

echo "Update successful!"
