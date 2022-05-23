#!/bin/bash

echo "*** Applying patch-001-23-May-2022 - GStreamer encoding changed to x264 with resolution and latency settings ***"

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

git clone https://github.com/sdarmonski/Jetson_Nano_Linux_Services.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-autostart.service /etc/systemd/system/
cp /home/$usr/Repos/Jetson_Nano_Linux_Services/gstreamer-setup /etc/default/

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Linux_Services

echo "Update successful!"
