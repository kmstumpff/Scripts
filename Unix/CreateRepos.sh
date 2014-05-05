#!/bin/bash

#Make sure user is root
export user=$(whoami)
if [ "$user" != "root" ]
then	
	echo "Script must be run as root to mount devfiles"
	exit 1
fi

#Determine the OS:
osname=$(uname -s)
GotInfo=0
LinuxDownload(){
#Get test files off of devfiles on Linux
########################################################################################################
echo "Connecting to devfiles server"
printf "Enter username [stumpffk]: "
read -r username
username=${username:-stumpffk}
printf "Enter password: "
read -s -r password
echo ""
echo ""
echo "Downloading files from devfiles server..."
mkdir .mountdir > /dev/null 2>&1
mkdir .tempdir > /dev/null 2>&1
mount -t cifs //devfiles/QA .mountdir/ -o username=$username,domain=SEAPINE,password=$password
printf "Copying directory [1 of 5]"
cp -r .mountdir/Surround\ Test\ Files/Misc\ Files/* .tempdir
printf "\rCopying directory [2 of 5]"
cp -r .mountdir/Surround\ Test\ Files/Activations/Release1/* .tempdir
printf "\rCopying directory [3 of 5]"
cp .mountdir/Surround\ Test\ Files/SCMServDbfirstandhalf.zip .tempdir
printf "\rCopying directory [4 of 5]"
cp -r .mountdir/KyleS/VM_Files/samplefiles/* .tempdir
printf "\rCopying directory [5 of 5]\n"
cp .mountdir/*.jpg .tempdir
echo "Finished downloading files!"
echo ""
umount .mountdir > /dev/null 2>&1
rmdir .mountdir > /dev/null 2>&1
########################################################################################################
}


MacDownload(){
#Get test files off of devfiles on Mac
########################################################################################################
echo "Connecting to devfiles server"
mkdir .mountdir > /dev/null 2>&1
mkdir .tempdir > /dev/null 2>&1
mount_smbfs //devfiles/QA .mountdir/ 
echo "Downloading files from devfiles server..."
echo "Copying directory [1 of 5]"
cp -r .mountdir/Surround\ Test\ Files/Misc\ Files/* .tempdir
echo "Copying directory [2 of 5]"
cp -r .mountdir/Surround\ Test\ Files/Activations/Release1/* .tempdir
echo "Copying directory [3 of 5]"
cp .mountdir/Surround\ Test\ Files/SCMServDbfirstandhalf.zip .tempdir
echo "Copying directory [4 of 5]"
cp -r .mountdir/KyleS/VM_Files/samplefiles/* .tempdir
echo "Copying directory [5 of 5]"
cp .mountdir/*.jpg .tempdir
echo "Finished downloading files!"
echo ""
umount .mountdir > /dev/null 2>&1
rmdir .mountdir > /dev/null 2>&1


########################################################################################################
}

GetSCMInfo() {
printf "Enter Surround username [Administrator]: "
read -r scm_un
scm_un=${scm_un:-Administrator}
printf "Enter password [ ]: "
read -r scm_pw
printf "Enter server address [localhost]: "
read -r scm_address
scm_address=${scm_address:-localhost}
printf "Enter port [4900]: "
read -r scm_port
scm_port=${scm_port:-4900}
#used incase user skips adding files
GotInfo=1
}

printf "Do you want to download and add files to Surround? [y/n]: "
read answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
	if [ "$osname" = "Darwin" ]
	then
		MacDownload
	else
		LinuxDownload
	fi

	#Add files to Surround
	########################################################################################################
	if [ $GotInfo -eq 0 ]
	then
		GetSCMInfo
	fi
	#getting first mainline
	mainline=$(sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port | head -n 1)
	echo "-------------------------"
	echo "Mainlines on this server:"
	echo $(sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port)
	echo "-------------------------"
	printf "Enter name of mainline to add files to [$mainline]: "
	read -r scm_mainline
	scm_mainline=${scm_mainline:-$mainline}
	#add files to mainline
	echo "Adding files to Surround mainline: $mainline"
	sscm add ".tempdir/*" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port 
	########################################################################################################

	#Remove tempdir
	rm -rf .tempdir > /dev/null 2>&1
fi
printf "Do you want to add test users to Surround? [y/n]: "
read answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
	if [ $GotInfo -eq 0 ]
	then
		GetSCMInfo
	fi
	printf "How many users do you want to add?: "
	read num_users
	for x in $(seq 1 $num_users); do
		#Find if user exists in license server
		lsuser_resp=$(sscm lsuser test$x -g -y$scm_un:$scm_pw -z$scm_address:$scm_port)
		if [ "$resp" ]
		then
			sscm rtu test$x -y$scm_un:$scm_pw -z$scm_address:$scm_port
			echo "user$x was retrieved from license server"
		else
			echo "Creating user$x..."
			sscm adduser test$x -fTest -lUser$x -wtest$x -ifloating -y$scm_un:$scm_pw -z$scm_address:$scm_port
		fi
	done
	group_resp=$(sscm lsgroup Testers -y$scm_un:$scm_pw -z$scm_address:$scm_port)
	if [ ! "$group_resp" ]
	then
		sscm addgroup Testers -sgeneral+all:admin+all:users+all:files+all:branch+all -y$scm_un:$scm_pw -z$scm_address:$scm_port
	fi
	for x in $(seq 1 $num_users); do
		sscm editgroup Testers -u+test$x -y$scm_un:$scm_pw -z$scm_address:$scm_port
	done
	echo "Users have been added to security group: Testers"
fi