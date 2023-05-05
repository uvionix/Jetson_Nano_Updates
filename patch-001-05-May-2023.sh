#!/bin/bash

echo "*** Applying patch-001-05-May-2023 - Adding sockets for IPC and camera control. Bug fixes ***"

# Stop the modem watchdog service
service modem-watchdog stop

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
rm /etc/systemd/system/gstreamer-autostart.service
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/gstreamer-start.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/modem-watchdog.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/switch-to-rtl.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/system-shutdown.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/update-uav-status.py /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-setup /etc/default/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/mavproxy-setup /etc/default/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/camera-start.socket /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/camera-start@.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/system-shutdown.service /etc/systemd/system/

echo "Modify file permissions..."
chmod +x /usr/local/bin/gstreamer-start.sh
chmod +x /usr/local/bin/modem-watchdog.sh
chmod +x /usr/local/bin/network-watchdog.sh
chmod +x /usr/local/bin/switch-to-rtl.sh
chmod +x /usr/local/bin/system-shutdown.sh
chmod +x /usr/local/bin/update-uav-status.py

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts
rm -d -r Jetson_Nano_Python_Scripts

echo "Start the modem watchdog service..."
service modem-watchdog start

echo "Update successful!"
