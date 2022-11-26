#!/bin/bash

echo "*** Applying patch-001-26-Nov-2022 - Adding the ability to disable auto switch to LOITER and/or RTL + fixed network disconnection bug ***"

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
cp /home/$usr/Repos/Jetson_Nano_Shell_Scripts/network-watchdog.sh /usr/local/bin/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/network-watchdog-setup /etc/default/

echo "Modify file permissions..."
chmod +x /usr/local/bin/network-watchdog.sh

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services
rm -d -r Jetson_Nano_Shell_Scripts

echo "Update successful!"
