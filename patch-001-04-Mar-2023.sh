#!/bin/bash

echo "*** Applying patch-001-04-Mar-2023 - Correcting issue in the MAVProxy service file, introduced with patch-001-01-Mar-2023 ***"

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

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/mavproxy-autostart.service /etc/systemd/system/

sed -i 's/%u/'"$usr"'/gi' /etc/systemd/system/mavproxy-autostart.service

echo "Reload daemons..."
systemctl daemon-reload

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services

echo "Update successful!"
