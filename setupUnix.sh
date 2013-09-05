#!/bin/bash
#
#Make sure user is root
export user=$(whoami)
if [ "$user" != "root" ]
then	
	echo "Script must be run as root"
	exit 1
fi 

echo "Determining the distribution you are using" 
#Determine the OS:
distro=$(head -1 /etc/issue | awk '{print $1}')

echo "Do you want to install findservers? [y/n]"
	read fs_answer
	if [ "$fs_answer" = "y" ] || [ "$fs_answer" = "Y" ]
	then
		#add the find server script to "/usr/bin"
		touch /usr/bin/fs
		> /usr/bin/fs
		echo "#!/bin/sh" >> /usr/bin/fs
		echo "#" >> /usr/bin/fs
		echo "# function to find the pid the license server" >> /usr/bin/fs
		echo "pidofspls() {" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo "    ps -ef > /tmp/ps.tbl 2> /dev/null" >> /usr/bin/fs
		echo "    pid=\`awk -F"\" "\" '/\/splicsvr/ {print \$2}' /tmp/ps.tbl\`" >> /usr/bin/fs
		echo "	rm -rf /tmp/ps.tbl > /dev/null 2>&1" >> /usr/bin/fs
		echo '    if [ "$pid" != "" ]' >> /usr/bin/fs
		echo "    then " >> /usr/bin/fs
		echo '        echo $pid' >> /usr/bin/fs
		echo "        return 0 " >> /usr/bin/fs
		echo "    fi" >> /usr/bin/fs
		echo "}" >> /usr/bin/fs
		echo "   " >> /usr/bin/fs
		echo "#function to find the pid of the surround server" >> /usr/bin/fs
		echo "pidofsurroundscm() {" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo "    ps -ef > /tmp/ps.tbl 2> /dev/null" >> /usr/bin/fs
		echo "    pid=\`awk -F"\" "\" '/\/scmserver/ {print \$2}' /tmp/ps.tbl\`" >> /usr/bin/fs
		echo "	rm -rf /tmp/ps.tbl > /dev/null 2>&1" >> /usr/bin/fs
		echo '    if [ "$pid" != "" ]' >> /usr/bin/fs
		echo "    then " >> /usr/bin/fs
		echo '        echo $pid' >> /usr/bin/fs
		echo "        return 0 " >> /usr/bin/fs
		echo "    fi" >> /usr/bin/fs
		echo "}" >> /usr/bin/fs
		echo "   " >> /usr/bin/fs
		echo "#function to find the pid of the surround proxy server" >> /usr/bin/fs
		echo "pidofsurroundscmproxy() {" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo "    ps -ef > /tmp/ps.tbl 2> /dev/null" >> /usr/bin/fs
		echo "    pid=\`awk -F"\" "\" '/\/scmproxyserver/ {print \$2}' /tmp/ps.tbl\`" >> /usr/bin/fs
		echo "	rm -rf /tmp/ps.tbl > /dev/null 2>&1" >> /usr/bin/fs
		echo '    if [ "$pid" != "" ]' >> /usr/bin/fs
		echo "    then " >> /usr/bin/fs
		echo '        echo $pid' >> /usr/bin/fs
		echo "        return 0 " >> /usr/bin/fs
		echo "    fi" >> /usr/bin/fs
		echo "}" >> /usr/bin/fs
		echo "   " >> /usr/bin/fs
		echo "#function to find the pid of the TestTrack server" >> /usr/bin/fs
		echo "pidofttstudio() {" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo "    ps -ef > /tmp/ps.tbl 2> /dev/null" >> /usr/bin/fs
		echo "    pid=\`awk -F"\" "\" '/\/ttserver/ {print \$2}' /tmp/ps.tbl\`" >> /usr/bin/fs
		echo "	rm -rf /tmp/ps.tbl > /dev/null 2>&1" >> /usr/bin/fs
		echo '    if [ "$pid" != "" ]' >> /usr/bin/fs
		echo "    then " >> /usr/bin/fs
		echo '        echo $pid' >> /usr/bin/fs
		echo "        return 0 " >> /usr/bin/fs
		echo "    fi" >> /usr/bin/fs
		echo "}" >> /usr/bin/fs
		echo 'pidls=`pidofspls $1`' >> /usr/bin/fs
		echo 'pidss=`pidofsurroundscm $1`' >> /usr/bin/fs
		echo 'pidsp=`pidofsurroundscmproxy $1`' >> /usr/bin/fs
		echo 'pidtt=`pidofttstudio $1`' >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo "#Output the results" >> /usr/bin/fs
		echo 'echo ""' >> /usr/bin/fs
		echo 'if [ "$pidls" != "" ]' >> /usr/bin/fs
		echo "then" >> /usr/bin/fs
		echo '    echo "The license server is running!"' >> /usr/bin/fs
		echo '    echo "The pid of spls is: $pidls"' >> /usr/bin/fs
		echo "else" >> /usr/bin/fs
		echo '    echo "The license server is not running!"' >> /usr/bin/fs
		echo "fi" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'echo ""' >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'if [ "$pidss" != "" ]' >> /usr/bin/fs
		echo "then" >> /usr/bin/fs
		echo '    echo "The Surround server is running!"' >> /usr/bin/fs
		echo '    echo "The pid of surroundscm is: $pidss"' >> /usr/bin/fs
		echo "else" >> /usr/bin/fs
		echo '    echo "The Surround server is not running!"' >> /usr/bin/fs
		echo "fi" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'echo ""' >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'if [ "$pidsp" != "" ]' >> /usr/bin/fs
		echo "then" >> /usr/bin/fs
		echo '    echo "The Surround proxy server is running!"' >> /usr/bin/fs
		echo '    echo "The pid of surroundscmproxy is: $pidss"' >> /usr/bin/fs
		echo "else" >> /usr/bin/fs
		echo '    echo "The Surround proxy server is not running!"' >> /usr/bin/fs
		echo "fi" >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'echo ""' >> /usr/bin/fs
		echo "" >> /usr/bin/fs
		echo 'if [ "$pidtt" != "" ]' >> /usr/bin/fs
		echo "then" >> /usr/bin/fs
		echo '    echo "The TestTrack server is running!"' >> /usr/bin/fs
		echo '    echo "The pid of ttstudio is: $pidtt"' >> /usr/bin/fs
		echo "else" >> /usr/bin/fs
		echo '    echo "The TestTrack server is not running!"' >> /usr/bin/fs
		echo "fi" >> /usr/bin/fs
		echo 'echo ""' >> /usr/bin/fs
		chmod 777 /usr/bin/fs
	fi


echo "Do you want to add aliases? [y/n]"
read fs_answer
if [ "$fs_answer" = "y" ] || [ "$fs_answer" = "Y" ]
then
	if [ "$distro" = "Ubuntu" ]
	then
		#need to add aliases to .bashrc in both seapine and root home directories
		
		#/home/seapine/.bashrc
		echo "alias la='ls -lah'" >> /home/seapine/.bashrc
		echo "alias ll='ls -lh'" >> /home/seapine/.bashrc
		echo "alias cd..='cd ..'"  >> /home/seapine/.bashrc
		echo "alias clr='clear'"  >> /home/seapine/.bashrc
		echo "alias sstart='surroundscm start'"  >> /home/seapine/.bashrc
		echo "alias sstop='surroundscm stop'"  >> /home/seapine/.bashrc
		echo "alias lstart='spls start'"  >> /home/seapine/.bashrc
		echo "alias lstop='spls stop'"  >> /home/seapine/.bashrc
		echo "alias spstart='spls start;surroundscm start'" >> /home/seapine/.bashrc
		echo "alias spstop='spls stop;surroundscm stop'" >> /home/seapine/.bashrc
		echo "alias sprestart='surroundscm stop;spls stop;sleep 10;spls start;surroundscm start'" >> /home/seapine/.bashrc
		echo "alias devfiles='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /home/seapine/.bashrc
		echo "alias qa='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /home/seapine/.bashrc
		echo "alias camelot='smbclient \\\\camelot\\UpcomingReleases -Useapine\\stumpffk'"  >> /home/seapine/.bashrc
		
		#/root/.bashrc
		echo "alias la='ls -lah'" >> /root/.bashrc
		echo "alias ll='ls -lh'" >> /root/.bashrc
		echo "alias cd..='cd ..'"  >> /root/.bashrc
		echo "alias clr='clear'"  >> /root/.bashrc
		echo "alias sstart='surroundscm start'"  >> /root/.bashrc
		echo "alias sstop='surroundscm stop'"  >> /root/.bashrc
		echo "alias lstart='spls start'"  >> /root/.bashrc
		echo "alias lstop='spls stop'"  >> /root/.bashrc
		echo "alias spstart='spls start;surroundscm start'" >> /root/.bashrc
		echo "alias spstop='spls stop;surroundscm stop'" >> /root/.bashrc
		echo "alias sprestart='surroundscm stop;spls stop;sleep 10;spls start;surroundscm start'" >> /root/.bashrc	
		echo "alias devfiles='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /root/.bashrc
		echo "alias qa='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /root/.bashrc
		echo "alias camelot='smbclient \\\\camelot\\UpcomingReleases -Useapine\\stumpffk'"  >> /root/.bashrc
		
	else
		#appending aliases to "/etc/bashrc"
		echo "alias la='ls -lah'" >> /etc/bashrc
		echo "alias ll='ls -lh'" >> /etc/bashrc
		echo "alias cd..='cd ..'"  >> /etc/bashrc
		echo "alias clr='clear'"  >> /etc/bashrc
		echo "alias sstart='surroundscm start'"  >> /etc/bashrc
		echo "alias sstop='surroundscm stop'"  >> /etc/bashrc
		echo "alias lstart='spls start'"  >> /etc/bashrc
		echo "alias lstop='spls stop'"  >> /etc/bashrc
		echo "alias spstart='spls start;surroundscm start'" >> /etc/bashrc
		echo "alias spstop='spls stop;surroundscm stop'" >> /etc/bashrc
		echo "alias sprestart='surroundscm stop;spls stop;sleep 10;spls start;surroundscm start'" >> /etc/bashrc
		echo "alias devfiles='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /etc/bashrc
		echo "alias qa='smbclient \\\\devfiles\\QA -Useapine\\stumpffk'"  >> /etc/bashrc
		echo "alias camelot='smbclient \\\\camelot\\UpcomingReleases -Useapine\\stumpffk'"  >> /etc/bashrc
	fi
fi
osname=$(uname -s)

#########################################
#OS X

if [ "$osname" = "Darwin" ]
then
	#simulate Linux commands on Mac OSX
	echo "alias lsadmin='/Applications/Seapine\ License\ Server/Seapine\ License\ Server\ Admin\ Utility.app/Contents/MacOS/Seapine\ License\ Server\ Admin'" >> /etc/bashrc
	echo "alias scmgui='/Applications/Surround\ SCM/Surround\ SCM\ Client.app/Contents/MacOS/Surround\ SCM'" >> /etc/bashrc
	
	#Download Surround
	echo "Do you want to download Surround to the Desktop? [y/n]"
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Enter the release version [i.e. 2013.2.0]"
		read release
		echo "Enter the build number [i.e. 1]"
		read buildnum
		export build="build$buildnum"
		echo "Enter username"
		read username
		echo "Enter password"
		read -s password
		echo "Downloading Surround SCM $release $build"
		mkdir tempdir
		mkdir /Users/seapine/Desktop/$build
		mount_smbfs //$username:$password@camelot/UpcomingReleases/SCM/$release/$build tempdir
		#clear password
		export password=""
		cp tempdir/sscmmacosxinstall.dgm.gz /Users/seapine/Desktop/$build
		umount tempdir
		rmdir tempdir
		echo "Extracting sscmmacosxinstall.dgm.gz"
		gzip -cd /Users/seapine/Desktop/$build/sscmmacosxinstall.dgm.gz
	fi
	
	#Installing Graphics Driver
	echo "Do you want to install the VMWare graphics driver? [y/n]"
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Downloading graphics driver..."
		mkdir tempdir
		mount_smbfs //stumpffk@excalibur/os/osx/VMWare%20Drivers tempdir
		cp tempdir/VMsvga2_v1.2.4_OS_10.6-7.pkg /Users/seapine/Desktop
		umount tempdir
		rmdir tempdir
		echo "Installing graphics driver..."
		open /Users/seapine/Desktop/VMsvga2_v1.2.4_OS_10.6-7.pkg
	fi
	#if user did not install driver
	#quitting Mac terminal to apply aliases
	echo "Are you sure you want to close all open terminal windows? [y/n]"
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		killall Terminal
	fi
	
#########################################
#Linux
else
	#Download Surround
	echo "Do you want to download Surround to the Desktop? [y/n]"
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Enter the release version [2013.2.0]"
		read release
		release=${release:-2013.2.0}
		echo "Enter the build number [19]"
		read buildnum
		buildnum=${buildnum:-19}
		export build="build$buildnum"
		echo "Enter username [stumpffk]"
		read username
		username=${username:-stumpffk}
		echo "Enter password"
		read -s password
		echo "Downloading Surround SCM $release $build"
		mkdir .tempdir
		mkdir /home/seapine/Desktop/$build
		mount -t cifs //camelot/UpcomingReleases/SCM/$release/$build .tempdir/ -o username=$username,domain=SEAPINE,password=$password
		#clear password
		export password=""
		cp .tempdir/sscmlinuxinstall.tar.gz /home/seapine/Desktop/$build
		umount .tempdir
		rmdir .tempdir
		echo "Extracting sscmlinuxinstall.tar.gz"
		tar -xf /home/seapine/Desktop/$build/sscmlinuxinstall.tar.gz /home/seapine/Desktop/$build
		chown seapine /home/seapine/Desktop/$build
		chgrp seapine /home/seapine/Desktop/$build
	fi
	#quitting Linux terminal to apply aliases
	echo "Are you sure you want to close all open terminal windows? [y/n]"
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		killall gnome-terminal
	fi
fi
