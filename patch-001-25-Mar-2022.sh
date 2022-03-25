#!/bin/bash

echo "*** Applying patch-001-25-Mar-2022 - Camera feed to host IP using GStreamer ***"

echo "Stopping network-watchdog service..."
service network-watchdog stop

echo "Stopping VPN service..."
service openvpn-autostart stop

echo "Stopping MAVProxy..."
service mavproxy-autostart stop

# Get the logged-in username
usr=$(logname)

# Create the download directory
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

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git
git clone https://github.com/sdarmonski/Jetson_Nano_Shell_Scripts.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-autostart.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-setup /etc/default/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/

chmod +x /usr/local/bin/network-watchdog.sh

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts

echo "Starting network-watchdog service..."
service network-watchdog start

echo "Update successful!"
