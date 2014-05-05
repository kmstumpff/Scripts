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

LinuxMount(){
echo "Connecting to devfiles server"
printf "Enter username [stumpffk]: "
read -r username
username=${username:-stumpffk}
printf "Enter password: "
read -s -r password
echo ""
mkdir .mountdir > /dev/null 2>&1
mount -t cifs //devfiles/QA .mountdir/ -o username=$username,domain=SEAPINE,password=$password
}
LinuxUmount () {
umount .mountdir > /dev/null 2>&1
rmdir .mountdir > /dev/null 2>&1
}


MacMount(){
echo "Connecting to devfiles server"
mkdir .mountdir > /dev/null 2>&1
mount_smbfs //devfiles/QA .mountdir/
}
MacUmount () {
umount .mountdir > /dev/null 2>&1
rmdir .mountdir > /dev/null 2>&1
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
		MacMount
	else
		LinuxMount
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
	echo "Adding directory [1 of 5]"
	sscm add ".mountdir/Surround\ Test\ Files/Misc\ Files/*" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
	echo "Adding directory [2 of 5]"
	sscm add ".mountdir/Surround\ Test\ Files/Activations/Release1/*" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
	echo "Adding directory [3 of 5]"
	sscm add ".mountdir/Surround\ Test\ Files/SCMServDbfirstandhalf.zip" -b$scm_mainline -c- -p$scm_mainline -q -y$scm_un:$scm_pw -z$scm_address:$scm_port
	echo "Adding directory [4 of 5]"
	sscm add ".mountdir/KyleS/VM_Files/samplefiles/*" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
	echo "Adding directory [5 of 5]"
	sscm add ".mountdir/*.jpg" -b$scm_mainline -c- -p$scm_mainline -q -y$scm_un:$scm_pw -z$scm_address:$scm_port 
	echo "Finished adding files!"
	########################################################################################################
	if [ "$osname" = "Darwin" ]
	then
		MacUMount
	else
		LinuxUMount
	fi
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