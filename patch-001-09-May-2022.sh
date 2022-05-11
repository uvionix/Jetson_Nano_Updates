#!/bin/bash

echo "*** Applying patch-001-09-May-2022 - Canceled automatic mode change upon loosing network connectivity when HERELINK airunit is connected ***"

# Get the logged-in username
usr=$(logname)

# Create the download directory
mkdir /home/$usr/Repos
cd /home/$usr/Repos

# Clone the new repositories
echo "Cloning repositories..."
repoexists=$(ls | grep "Jetson_Nano_Python_Scripts")

if [ ! -z "$repoexists" ]
then
	rm -d -r Jetson_Nano_Python_Scripts
fi

git clone https://github.com/sdarmonski/Jetson_Nano_Python_Scripts.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/Jetson_Nano_Python_Scripts/chmod_offline.py /usr/local/bin/

chmod +x /usr/local/bin/chmod_offline.py

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r Jetson_Nano_Python_Scripts

echo "Update successful!"
