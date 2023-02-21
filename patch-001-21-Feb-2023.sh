#!/bin/bash

echo "*** Applying patch-001-21-Feb-2023 - Dynamic gstreamer pipeline implemented for camera recording ***"

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

repoexists=$(ls | grep "Jetson_Nano_Binaries")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Binaries
fi

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git
git clone https://github.com/sdarmonski/Jetson_Nano_Shell_Scripts.git
git clone https://github.com/sdarmonski/Jetson_Nano_Binaries.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-setup /etc/default/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-autostart.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/gstreamer-start.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Binaries/gst-start-camera /usr/local/bin/

echo "Modify file permissions..."
chmod +x /usr/local/bin/gstreamer-start.sh
chmod +x /usr/local/bin/network-watchdog.sh
chmod +x /usr/local/bin/gst-start-camera

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts
rm -d -r Jetson_Nano_Binaries

echo "Update successful!"
