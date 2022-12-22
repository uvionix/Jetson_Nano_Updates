#!/bin/bash

echo "*** Applying patch-002-22-Dec-2022 - Adding camera probe service invoked if LTE connection is selected ***"

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

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git
git clone https://github.com/sdarmonski/Jetson_Nano_Shell_Scripts.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-camera-probe.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/gstreamer-camera-probe.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/

echo "Modify file permissions..."
chmod +x /usr/local/bin/gstreamer-camera-probe.sh
chmod +x /usr/local/bin/network-watchdog.sh

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts

echo "Update successful!"
