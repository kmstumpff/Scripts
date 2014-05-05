#!/bin/bash

#Determine the OS:
osname=$(uname -s)
GotInfo=0
##################
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

##################
PrintMainlines() {
echo ""
echo "Mainlines currently on this server:"
echo "-----------------------------------"
sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port
}

##################
EditFiles() {
#Add text to all files in specific directory
FILES="$1/*"
for f in $FILES
do
	echo "Editing $f"
	echo "Version $2" >> $f
done
}
main() {
#get mainlines
if [ $GotInfo -eq 0 ]
then
	GetSCMInfo
fi
mainline=$(sscm lsmainline -y$scm_un:$scm_pw -z$scm_address:$scm_port | head -n 1)
PrintMainlines
printf "Enter name of mainline to add files to [$mainline]: "
read -r scm_mainline
scm_mainline=${scm_mainline:-$mainline}
if [ "$osname" = "Darwin" ]
then
	#Create Mac working directories
	mkdir /Users/seapine/WDs
	mkdir /Users/seapine/WDs/$scm_mainline-Mainline-$scm_un
	wd_ml="/Users/seapine/WDs/$scm_mainline-Mainline-$scm_un"
	mkdir /Users/seapine/WDs/$scm_mainline-Baseline-$scm_un
	wd_bl="/Users/seapine/WDs/$scm_mainline-Baseline-$scm_un"

else
	#Create Linux working directories
	mkdir /home/seapine/WDs
	mkdir /home/seapine/WDs/$scm_mainline-Mainline-$scm_un
	wd_ml="/home/seapine/WDs/$scm_mainline-Mainline-$scm_un"
	mkdir /home/seapine/WDs/$scm_mainline-Baseline-$scm_un
	wd_bl="/home/seapine/WDs/$scm_mainline-Baseline-$scm_un"

fi

#Names of branches
Baseline="Baseline-$scm_mainline-$scm_un"
Snapshot="Snapshot-$scm_mainline-$scm_un"
Workspace="Workspace-$scm_mainline-$scm_un"

#Name of paths for branchs
path_bl="$scm_mainline/Agents"
path_ws="$scm_mainline/WFM"

#Set working directory of mainline
echo "sscm workdir $wd_ml $scm_mainline -b$scm_mainline -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm workdir $wd_ml $scm_mainline -b$scm_mainline -r -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Get files to working directory
echo "sscm get '*' -b$scm_mainline -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm get "*" -b$scm_mainline -p$scm_mainline -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Create Baseline Branch from Agents repo
echo "sscm mkbranch $Baseline $path_bl -b$scm_mainline -c- -sbaseline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm mkbranch $Baseline $path_bl -b$scm_mainline -c- -sbaseline -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Set working directory of Baseline
echo "sscm workdir $wd_bl $path_bl -b$Baseline -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm workdir $wd_bl $path_bl -b$Baseline -r -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Get files to working directory
echo "sscm get '*' -b$Baseline -p$path_bl -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm get "*" -b$Baseline -p$path_bl -q -r -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Remove and destroy UserImport recursively in baseline branch
echo "sscm rm UserImport -b$Baseline -c- -d -f -p$path_bl -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rm UserImport -b$Baseline -c- -d -f -p$path_bl -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Rebase Baseline
echo "sscm rebase $Baseline -p$path_bl -c- -s -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rebase $Baseline -p$path_bl -c- -s -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Check out zz_iModelPrototype recursively on Mainline
echo "sscm checkout zz_iModelPrototype -b$scm_mainline -p$scm_mainline -c- -f -r -q -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkout zz_iModelPrototype -b$scm_mainline -p$scm_mainline -c- -f -r -q -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Check in zz_iModelPrototype recursively on Mainline and update version number
echo "sscm checkin zz_iModelPrototype -b$scm_mainline -p$scm_mainline -c- -q -r -u -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkin zz_iModelPrototype -b$scm_mainline -p$scm_mainline -c- -q -r -u -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Label WEB-INF on Mainline with label: Label_WEB-INF
echo "sscm label '*' -b$scm_mainline -p$scm_mainline/WEB-INF -c- -lLabel_WEB-INF -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm label "*" -b$scm_mainline -p$scm_mainline/WEB-INF -c- -lLabel_WEB-INF -r -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Check out MixedAuth on Baseline
echo "sscm checkout MixedAuth -b$Baseline -p$path_bl -c- -f -q -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkout MixedAuth -b$Baseline -p$path_bl -c- -f -q -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Edit files in MixedAuth with version 2
WD_MA="$wd_bl/MixedAuth"
EditFiles $WD_MA 2

#Check in ^^
echo "sscm checkin MixedAuth -b$Baseline -p$path_bl -c- -f -q -u -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkin MixedAuth -b$Baseline -p$path_bl -c- -f -q -u -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Promote Baseline branch
echo "sscm promote $Baseline -c- -p$path_bl -s -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm promote $Baseline -c- -p$path_bl -s -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Remove directory /TMS/Conversion on Mainline recursively
echo "sscm rm Conversion -b$scm_mainline -c- -f -p$scm_mainline/TMS -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rm Conversion -b$scm_mainline -c- -f -p$scm_mainline/TMS -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Check out MPS/archive on Mainline
echo "sscm checkout '*' -b$scm_mainline -p$scm_mainline/MPS/archive -c- -f -r -q -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkout archive -b$scm_mainline -p$scm_mainline/MPS -c- -f -r -q -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Edit files in archive with version 2

WD_A=$wd_ml/MPS/archive
chmod 777 $WD_A/*
EditFiles $WD_A 2

#Check in ^^ with changelist "$scm_un:$scm_pw: date_time"
Name_CL="$scm_un:$scm_pw:$(date +%D_%T)"
echo "sscm checkin archive -b$scm_mainline -p$scm_mainline/MPS -c- -f -r -q -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm checkin archive -b$scm_mainline -p$scm_mainline/MPS -c- -f -r -q -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Get CLID from user
echo "sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port
printf "\nSurround insists on using changelist IDs to commit a changelist...\n"
printf "Please enter the changelist ID: "
read CLID
echo "Thank you"

#Commit changelist ^^
echo "sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Sleep 2 second for changelist
echo "sleep 2"
sleep 2

#Remove directory ITSamples/VBSamples/ajax on Mainline recursively with changelist
Name_CL="$scm_un:$scm_pw:$(date +%D_%T)"
echo "sscm rm ajax -b$scm_mainline -c- -f -p$scm_mainline/ITSamples/VBSamples -q -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rm ajax -b$scm_mainline -c- -f -p$scm_mainline/ITSamples/VBSamples -q -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Get CLID from user
echo "sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port
printf "\nPlease enter the changelist ID: "
read CLID
echo "Thank you"

#Commit changelist ^^
echo "sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Share iCert/Templates to ICC4 on Mainline
echo "sscm share $scm_mainline/iCert/Templates -b$scm_mainline -c- -r -p$scm_mainline/ICC4 -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm share $scm_mainline/iCert/Templates -b$scm_mainline -c- -r -p$scm_mainline/ICC4 -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Share iCert/Templates to ICC3_GUI_3.6.X on Mainline
echo "sscm share $scm_mainline/iCert/Templates -b$scm_mainline -c- -r -p$scm_mainline/ICC3_GUI_3.6.X -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm share $scm_mainline/iCert/Templates -b$scm_mainline -c- -r -p$scm_mainline/ICC3_GUI_3.6.X -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Break share in ICC3_GUI_3.6.X on Mainline
#echo "sscm breakshare '*' -b$scm_mainline -c- -p$scm_mainline/ICC3_GUI_3.6.X/Templates -y$scm_un:$scm_pw -z$scm_address:$scm_port"
#sscm breakshare "*" -b$scm_mainline -c- -r -p$scm_mainline/ICC3_GUI_3.6.X/Templates -y$scm_un:$scm_pw -z$scm_address:$scm_port

#sleep 2 seconds for changelist
echo "sleep 2"
sleep 2

#Rename DMX/ttutil.rb to ttutil_renamed.rb with changelist on Mainline
Name_CL="$scm_un:$scm_pw:$(date +%D_%T)"
echo "sscm rename ttutil.rb ttutil_renamed.rb -b$scm_mainline -p$scm_mainline/DMX -c- -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rename ttutil.rb ttutil_renamed.rb -b$scm_mainline -p$scm_mainline/DMX -c- -x$Name_CL -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Get CLID from user
echo "sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm lschangelist -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port
printf "\nPlease enter the changelist ID: "
read CLID
echo "Thank you"

#Commit changelist
echo "sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm commitchangelist $CLID -p$scm_mainline -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Create Snapshot branch of the whole Mainline
echo "sscm mkbranch $Snapshot $scm_mainline -b$scm_mainline -c- -ssnapshot -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm mkbranch $Snapshot $scm_mainline -b$scm_mainline -c- -ssnapshot -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Create Workspace branch of WFM on Mainline
echo "sscm mkbranch $Workspace $scm_mainline/WFM -b$scm_mainline -c- -sworkspace -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm mkbranch $Workspace $scm_mainline/WFM -b$scm_mainline -c- -sworkspace -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Remove directory Production_051203 recursively on Workspace branch
echo "sscm rm Production_051203 -b$Workspace -c- -f -p$path_ws -r -y$scm_un:$scm_pw -z$scm_address:$scm_port"
sscm rm Production_051203 -b$Workspace -c- -f -p$path_ws -y$scm_un:$scm_pw -z$scm_address:$scm_port

#Repeat for additional mainlines
printf "Would you like to perform these actions to another mainline? [y/n]: "
read answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
	echo "main"
	main
else
	exit 0
fi
}
#Run the main program at least once
main



























