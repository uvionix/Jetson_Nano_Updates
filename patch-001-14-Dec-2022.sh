#!/bin/bash

echo "*** Applying patch-001-14-Dec-2022 - Installing apache webserver ***"

# Update repositories
echo "Updating repositories..."
sleep 3
apt-get update | tee apt-get-errors

update_errors=$(grep "Err" apt-get-errors)
rm apt-get-errors

if [ -z "$update_errors" ]
then
	echo "Installing apache webserver..."
	sleep 3
	apt-get install -y apache2

	installation_successful=$(ls /var/www/html/ | grep -m1 -o "index.html")

	if [ ! -z "$installation_successful" ]
	then
		echo "Update successful!"
		exit 0
	else
		echo "Installing apache webserver failed!"
		exit 1
	fi
else
	echo "Updating repositories failed!"
	exit 1
fi
