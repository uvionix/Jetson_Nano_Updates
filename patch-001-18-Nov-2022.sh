#!/bin/bash

echo "*** Applying patch-001-18-Nov-2022 - Fixed a bug where the network was not treated as disconnected when the respective interface is unavailable ***"

# Get the logged-in username
usr=$(logname)

# Create the download directory
mkdir /home/$usr/Repos
cd /home/$usr/Repos

# Clone the new repositories
echo "Cloning repositories..."
repoexists=$(ls | grep "Jetson_Nano_Shell_Scripts")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Shell_Scripts
fi

git clone https://github.com/sdarmonski/Jetson_Nano_Shell_Scripts.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/

echo "Modify file permissions..."
chmod +x /usr/local/bin/network-watchdog.sh

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Shell_Scripts

echo "Update successful!"
