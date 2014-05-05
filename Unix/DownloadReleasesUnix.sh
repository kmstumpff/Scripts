#!/bin/bash
#
#Make sure user is root
export user=$(whoami)
if [ "$user" != "root" ]
then	
	echo "Script must be run as root"
	exit 1
fi 


#########################################
#Linux
#Download Surround
printf "Enter the release year [2013]: "
read release_year
release_year=${release_year:-2013}
printf "Enter the release version [.2.0]: "
read release_version
release_version=${release_version:-.2.0}
year_version=$release_year$release_version
printf "Enter username [stumpffk]: "
read username
username=${username:-stumpffk}
printf "Enter password: "
read -s password
echo ""
echo "Downloading Surround SCM $year_version"
mkdir .tempdir
mkdir /home/seapine/Desktop/$year_version
mount -t cifs //devfiles/SoftwareReleases/SCM"$release_year"x/"Surround "$release_year$release_version\WebSite_Installers .tempdir/ -o username=$username,domain=SEAPINE,password=$password
#clear password
export password=""
cp .tempdir/sscmlinuxinstall.tar.gz /home/seapine/Desktop/$year_version
umount .tempdir
rmdir .tempdir
echo "Extracting sscmlinuxinstall.tar.gz"
tar -xf /home/seapine/Desktop/$year_version/sscmlinuxinstall.tar.gz -C /home/seapine/Desktop/$year_version
chown seapine /home/seapine/Desktop/$year_version
chgrp seapine /home/seapine/Desktop/$year_version
echo "SCM install directory: /home/seapine/Desktop/$year_version"