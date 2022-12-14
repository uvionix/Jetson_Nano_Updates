#!/bin/bash

echo "*** Applying patch-002-14-Dec-2022 - Adding XOSS Webpage ***"

# Get the logged-in username
usr=$(logname)

# Create the necessary directories
mkdir -p /var/www/html/js
mkdir -p /var/www/html/css

# Create the necessary files
cd /var/www/html/
echo "modem-latest-status" | tee modem-latest-status > /dev/null
echo "modem-watchdog" | tee modem-watchdog > /dev/null
echo "network-watchdog" | tee network-watchdog > /dev/null
echo "uav-latest-status" | tee uav-latest-status > /dev/null

# Create the download directory
mkdir /home/$usr/Repos
cd /home/$usr/Repos

# Clone the new repositories
echo "Cloning repositories..."
repoexists=$(ls | grep "XOSS_Webpage")

if [ ! -z "$repoexists" ]
then
	rm -d -r XOSS_Webpage
fi

git clone https://github.com/sdarmonski/XOSS_Webpage.git

# Copy the new files over the old ones
echo "Copying new files..."
cp /home/$usr/Repos/XOSS_Webpage/index.html /var/www/html/
cp /home/$usr/Repos/XOSS_Webpage/fetch-log.js /var/www/html/js/
cp /home/$usr/Repos/XOSS_Webpage/fetch-uav-status.js /var/www/html/js/
cp /home/$usr/Repos/XOSS_Webpage/log-suggestions.js /var/www/html/js/
cp /home/$usr/Repos/XOSS_Webpage/style.css /var/www/html/css/

# Delete created repositories
echo "Removing downloaded repositories..."
rm -d -r XOSS_Webpage

echo "Update successful!"
