#!/bin/bash

#Make sure user is root
export user=$(whoami)
if [ "$user" != "root" ]
then	
	echo "Script must be run as root to mount devfiles"
	exit 1
fi

# Functions
######################################################
GetStartTime() {
start_sec=$(date +%S)
start_min=$(date +%M)
start_hour=$(date +%H)
}

GetEndTime() {
end_sec=$(date +%S)
end_min=$(date +%M)
end_hour=$(date +%H)
}

DisplayTotalTime() {
tot_hour=$(($end_hour - $start_hour))
tot_min=$(($end_min - $start_min))
tot_sec=$(($end_sec - $start_sec))
if [ "$tot_sec" -lt "0" ]
then
	tot_min=$(($tot_min - 1))
	tot_sec=$(($tot_sec + 60))
fi
if [ "$tot_min" -lt "0" ]
then
	tot_hour=$(($tot_hour - 1))
	tot_min=$(($tot_min + 60))
fi
if [ "$tot_sec" -le "9" ]
then
	tot_sec="0"$tot_sec
fi
if [ "$tot_min" -le "9" ]
then
	tot_min="0"$tot_min
fi
if [ "$tot_hour" -le "9" ]
then
	tot_hour="0"$tot_hour
fi
echo "Start time: $start_hour:$start_min:$start_sec"
echo "End time: $end_hour:$end_min:$end_sec"
echo "Elapsed time: $tot_hour:$tot_min:$tot_sec"
}
# End Functions
######################################################


# Do stuff here
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if [ -d Unzip ]
then
	echo "Cleaning up..."
	rm -rf Unzip
fi
echo "Connecting to devfiles server"
printf "Enter username [stumpffk]: "
read -r username
username=${username:-stumpffk}
printf "Enter password: "
read -s -r password
echo ""
echo ""
echo "Downloading filefrom devfiles server..."
# Get Starting Time
GetStartTime
mkdir .mountdir > /dev/null 2>&1
mkdir Unzip > /dev/null 2>&1
mount -t cifs //devfiles/QA/KyleS .mountdir/ -o username=$username,domain=SEAPINE,password=$password
echo "Copying zip file"
cp -r .mountdir/Original.zip Unzip
echo "Unzipping file"
unzip -q Unzip/Original.zip -d Unzip
# Get End Time
GetEndTime
echo "Finished downloading files!"
echo ""
umount .mountdir > /dev/null 2>&1
rmdir .mountdir > /dev/null 2>&1
# Stop doing stuff here
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Display Timing Results
DisplayTotalTime
