#!/bin/bash

#Determine the OS:
osname=$(uname -s)
GotInfo=0

GetFilePath() {
printf "Enter path to folder [/home/seapine/Desktop/Original]: "
read file_path
file_path=${file_path:-"/home/seapine/Desktop/Original"}
printf "File path is $file_path - Is this correct? [y/n]: "
read answ
if [ "$answ" == "n" ]
then
	GetFilePath
fi
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

PrintMainlines() {
echo ""
echo "Mainlines currently on this server:"
echo "-----------------------------------"
sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port
}

AddFiles() {
	printf "Do you want to download and add files to Surround? [y/n]: "
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		GetFilePath
		#Add files to Surround
		########################################################################################################
		if [ $GotInfo -eq 0 ]
		then
			GetSCMInfo
		fi
		#getting first mainline
		PrintMainlines
		mainline=$(sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port | head -n 1)
		printf "Enter name of mainline to add files to [$mainline]: "
		read -r scm_mainline
		scm_mainline=${scm_mainline:-$mainline}
		#add files to mainline
		########################################################################################################
		echo "Adding directory [1 of 20]"
		sscm add "$file_path/ADP --test" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [2 of 20]"
		sscm add "$file_path/Agents" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [3 of 20]"
		sscm add "$file_path/DMX" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [4 of 20]"
		sscm add "$file_path/ICC3_GUI_3.6.X" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [5 of 20]"
		sscm add "$file_path/ICC4" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [6 of 20]"
		sscm add "$file_path/iCERT" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [7 of 20]"
		sscm add "$file_path/INews" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [8 of 20]"
		sscm add "$file_path/ITSamples" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [9 of 20]"
		sscm add "$file_path/MPS" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [10 of 20]"
		sscm add "$file_path/MPS Dedupe" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [11 of 20]"
		sscm add "$file_path/Pike Team" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [12 of 20]"
		sscm add "$file_path/SolWeb_Old" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [13 of 20]"
		sscm add "$file_path/SupportMatrix" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [14 of 20]"
		sscm add "$file_path/TMS" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [15 of 20]"
		sscm add "$file_path/unicode" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [16 of 20]"
		sscm add "$file_path/Utilities" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [17 of 20]"
		sscm add "$file_path/WEB-INF" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [18 of 20]"
		sscm add "$file_path/WFM" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [19 of 20]"
		sscm add "$file_path/WSApplicant_1" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
		echo "Adding directory [20 of 20]"
		sscm add "$file_path/zz_iModelPrototype" -b$scm_mainline -c- -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port
	fi
	MakeMainline
}
MakeMainline() {
printf "Do you want to create a new mainline to add files to? [y/n]: "
read new_mainline
if [ "$new_mainline" == "y" ]
then
	if [ $GotInfo -eq 0 ]
	then
		GetSCMInfo
	fi
	PrintMainlines
	printf "Enter the name of new mainline: "
	read name_mainline
	sscm mkmainline $name_mainline -c- -y$scm_un:$scm_pw -z$scm_address:$scm_port
	AddFiles
else
	addfiles=1
fi
}
addfiles=0
MakeMainline
if [ $addfiles -eq 1 ]
then
	AddFiles
fi
