#!/bin/bash
#********************************************************************
#**********************************************************************
# Description:
#	This script was built to setup new testing environments
#	with basic tools and files needed to get going.
#
# Functions:
# 	1.  Install the findserver script to /usr/bin/fs
# 		This script was made to tell the user if the local
# 		Seapine servers are running.
#
#	2.	Creates several aliases to make working from the
# 		Terminal easier.
#
# 	3.	Installs Homebrew as well as wget and emacs. ( Mac Only )
#
# 	4.	Downloads the specified version of Surround SCM to
# 		the Desktop.
#
#	5.	Sets up default settings ( Mac Only )
#
# 	6.	Installs the VMWare Graphics Driver. ( Mac Only )
#
# 	7.	Runs the 32-bit library setup script if it
#		exists in the current directory ( Linux Only )
#
# 	8.	The terminal will be closed to apply changes
# 		Asks only if aliases where added
#
# Testing:
# 	This setup script has only been tested on
# 		- Mac OS X 10.7 - 10.9
#		- Ubuntu 13.04, 13.10 & 14.04
# 		- CentOS 6.4
# 		- Fedora 18 & 19
#		- Suse 12
#
# Known Bugs:
#	None.
#
# Fixed Bugs:
#	Ubuntu 13.04 & Debian 6- Mounting camelot fails which prevents the script from downloading Surround to the Desktop
#		- Installs cifs-utils and smbfs packages on Ubuntu and Debian
#
# Issues:
# 	If any issues are found while using this script,
#	email stumpffk@seapine.com with the problem.
# 	Please include the OS and distribution name ( Linux Only )
#
#
#**********************************************************************
#********************************************************************

#Make sure user is root
if [ $(whoami) != "root" ]
then
   #User is not root or using sudo...
   #If script exists in the current working directory, we can relaunch with elevated privileges.
   setupUnix="setupUnix.sh"
	if [ -f $setupUnix ]
   then
      sudo bash $setupUnix
      exit 0
   else
      #We don't know where the script is. User must relaunch manually as root or with sudo.
      echo "Script must be run as root"
      exit 1
   fi
fi

while [ 0 -lt 1 ]
do
	if [[ -f setup.conf ]]
	then
		c_username=$(cat setup.conf | grep compuser | awk '{print $2;}')
		username=$(cat setup.conf | grep spuser | awk '{print $2;}')
		if [ "$c_username" != "" ] || [ "$username" != "" ]
		then
			echo "Loaded configuration file"
			break
		else
			echo "Configuration file is corrupt. Deleting and trying again."
			rm setup.conf
		fi
	else
		printf "Please enter this computer's username [seapine]: "
		read c_username
		c_username=${c_username:-seapine}

		printf "Please enter your Seapine username: "
		read username

		echo "Saving info to setup.conf"
		echo "compuser $c_username" > setup.conf
		echo "spuser $username" >> setup.conf
	fi
done

osname=$(uname -s)


if [ "$osname" = "Linux" ]
then
	#Determine the distro of Linux:
	printf "Determining the distribution you are using... " 
	distro=$(head -1 /etc/issue | awk '{print $1}')
	if [[ "$distro" != "Welcome" ]]
	then
		echo "This is $distro"
	else
		echo "This is OpenSUSE"
	fi
fi

if [[ "$(cat setup.conf | grep findservers | awk '{print $2;}')" = "yes" ]]
then
	echo "findservers already exists. Skipping..."
else
	printf "Do you want to install findservers? [y/n]: "
	read fs_answer
	if [ "$fs_answer" = "y" ] || [ "$fs_answer" = "Y" ]
	then
		echo "findservers yes" >> setup.conf
		#Creates script at "/usr/bin/fs to display which Seapine servers are running"
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
                echo "#function to find the pid of the surround web server" >> /usr/bin/fs
                echo "pidofsurroundscmweb() {" >> /usr/bin/fs
                echo "" >> /usr/bin/fs
                echo "    ps -ef > /tmp/ps.tbl 2> /dev/null" >> /usr/bin/fs
                echo "    pid=\`awk -F"\" "\" '/\/sscmweb.jar/ {print \$2}' /tmp/ps.tbl\`" >> /usr/bin/fs
                echo "  rm -rf /tmp/ps.tbl > /dev/null 2>&1" >> /usr/bin/fs
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
                echo 'pidsw=`pidofsurroundscmweb $1`' >> /usr/bin/fs
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
                echo 'if [ "$pidsw" != "" ]' >> /usr/bin/fs
                echo "then" >> /usr/bin/fs
                echo '    echo "The Surround web server is running!"' >> /usr/bin/fs
                echo '    echo "The pids of surroundscmweb is: $pidsw"' >> /usr/bin/fs
                echo "else" >> /usr/bin/fs
                echo '    echo "The Surround web server is not running!"' >> /usr/bin/fs
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
fi

if [[ "$(cat setup.conf | grep aliases | awk '{print $2;}')" = "yes" ]]
then
	echo "Aliases have already been installed. Skipping..."
else
	printf "Do you want to add aliases? [y/n]: "
	read al_answer
	if [ "$al_answer" = "y" ] || [ "$al_answer" = "Y" ]
	then
		echo "aliases yes" >> setup.conf
		if [[ ("$distro" = "Ubuntu") || ("$distro" = "Welcome") || ("$distro" = "Debian") ]]
		then
			# Add .bashrc to root's home dir
			if [ "$distro" = "Welcome" ]
			then
				cp /etc/skel/.bash* /root/
			fi

			#need to add aliases to .bashrc in both $c_username and root home directories

			#/home/$c_username/.bashrc
			echo "alias la='ls -lAh'" >> /home/$c_username/.bashrc
			echo "alias ll='ls -lh'" >> /home/$c_username/.bashrc
			echo "alias cd..='cd ..'"  >> /home/$c_username/.bashrc
			echo "alias clr='clear'"  >> /home/$c_username/.bashrc
			echo "alias sstart='surroundscm start'"  >> /home/$c_username/.bashrc
			echo "alias sstop='surroundscm stop'"  >> /home/$c_username/.bashrc
			echo "alias lstart='spls start'"  >> /home/$c_username/.bashrc
			echo "alias lstop='spls stop'"  >> /home/$c_username/.bashrc
			echo "alias spstart='spls start;surroundscm start'" >> /home/$c_username/.bashrc
			echo "alias spstop='spls stop;surroundscm stop'" >> /home/$c_username/.bashrc
			echo "alias sprestart='surroundscm stop;spls stop;sleep 10;spls start;surroundscm start'" >> /home/$c_username/.bashrc
			echo "alias devfiles='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /home/$c_username/.bashrc
			echo "alias qa='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /home/$c_username/.bashrc
			echo "alias camelot='smbclient \\\\\\\\camelot\\\\UpcomingReleases -Useapine\\\\$username'"  >> /home/$c_username/.bashrc
			echo "alias dellcoop2='smbclient \\\\\\\\DELLCOOP2\\\\Users\\\\stumpffk -Useapine\\\\$username'"  >> /home/$c_username/.bashrc
			echo "alias pgadmin='/usr/local/pgsql/scripts/launchpgadmin.sh'" >> /home/$c_username/.bashrc

			#/root/.bashrc
			echo "alias la='ls -lAh'" >> /root/.bashrc
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
			echo "alias devfiles='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /root/.bashrc
			echo "alias qa='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /root/.bashrc
			echo "alias camelot='smbclient \\\\\\\\camelot\\\\UpcomingReleases -Useapine\\\\$username'"  >> /root/.bashrc
			echo "alias dellcoop2='smbclient \\\\\\\\DELLCOOP2\\\\Users\\\\stumpffk -Useapine\\\\$username'"  >> /root/.bashrc
			echo "alias pgadmin='/usr/local/pgsql/scripts/launchpgadmin.sh'" >> /root/.bashrc

		else
			#appending aliases to "/etc/bashrc"
			echo "alias la='ls -lAh'" >> /etc/bashrc
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
			echo "alias devfiles='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /etc/bashrc
			echo "alias qa='smbclient \\\\\\\\devfiles\\\\QA -Useapine\\\\$username'"  >> /etc/bashrc
			echo "alias camelot='smbclient \\\\\\\\camelot\\\\UpcomingReleases -Useapine\\\\$username'"  >> /etc/bashrc
			echo "alias dellcoop2='smbclient \\\\\\\\DELLCOOP2\\\\Users\\\\stumpffk -Useapine\\\\$username'"  >> /etc/bashrc
			echo "alias pgadmin='/usr/local/pgsql/scripts/launchpgadmin.sh'" >> /etc/bashrc
		fi
	fi
fi

#########################################
#OS X

if [ "$osname" = "Darwin" ]
then
	#simulate Linux commands on Mac OSX
	echo "alias lsadmin='/Applications/Seapine\ License\ Server/Seapine\ License\ Server\ Admin\ Utility.app/Contents/MacOS/Seapine\ License\ Server\ Admin'" >> /etc/bashrc
	echo "alias scmgui='/Applications/Surround\ SCM/Surround\ SCM\ Client.app/Contents/MacOS/Surround\ SCM'" >> /etc/bashrc


	#Install Homebrew and a few cli programs
	printf "Do you want to install homebrew? [y/n]: "
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Installing Homebrew"
		sudo -u $c_username ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
		printf "Did homebrew install correctly? [y/n]: "
		read answer
		if [ "$answer" = "n" ] || [ "$answer" = "N" ]
		then
			printf "Make sure Xcode stuff installs correctly then hit any key to try again: "
			read -s -n 1
			sudo -u $c_username ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
		fi
		sudo -u $c_username brew doctor
		sudo -u $c_username brew update
		sudo -u $c_username brew install wget
		sudo -u $c_username brew install emacs
	fi

	#Download Surround
	printf "Do you want to download Surround to the Desktop? [y/n]: "
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Enter the release version [i.e. 2014.0.0]"
		read release
		echo "Enter the build number [i.e. 1]"
		read buildnum
		export build="build$buildnum"
		echo "Enter password for $username: "
		read -s password
		echo ""
		echo "Downloading Surround SCM $release $build"
		mkdir tempdir
		mkdir /Users/$c_username/Desktop/$build
		mount_smbfs //$username@camelot/UpcomingReleases/SCM/$release/$build tempdir
		#clear password
		export password=""
		cp tempdir/sscmmacosxinstall.dmg.gz /Users/$c_username/Desktop/$build
		umount tempdir
		rmdir tempdir
		echo "Extracting sscmmacosxinstall.dgm.gz"
		gzip -d /Users/$c_username/Desktop/$build/sscmmacosxinstall.dmg.gz
		chown $c_username:staff /Users/$c_username/Desktop/$build/sscmmacosxinstall.dmg
	fi

	# Set up default settings
	printf "Do you want to change default settings for Finder and Dock? [y/n]: "
	read defaults_answer
	if [ "$defaults_answer" = "y" ] || [ "$defaults_answer" = "Y" ]
	then
		# Finder: allow quitting via COMMAND + Q; doing so will also hide desktop icons
		defaults write com.apple.finder QuitMenuItem -bool true
		# Finder: disable window animations and Get Info animations
		defaults write com.apple.finder DisableAllAnimations -bool true
		# Show icons for hard drives, servers, and removable media on the desktop
		defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
		defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
		defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
		defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
		# Finder: show hidden files by default
		defaults write com.apple.finder AppleShowAllFiles -bool true
		# Finder: show status bar
		defaults write com.apple.finder ShowStatusBar -bool true
		# Finder: show path bar
		defaults write com.apple.finder ShowPathbar -bool true
		# When performing a search, search the current folder by default
		defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
		# Show the ~/Library folder
		chflags nohidden ~/Library
		# restart Finder
		killall "Finder" > /dev/null 2>&1
		# Don’t animate opening applications from the Dock
		defaults write com.apple.dock launchanim -bool false
		# Speed up Mission Control animations
		defaults write com.apple.dock expose-animation-duration -float 0.1
		# restart Dock
		killall "Dock" > /dev/null 2>&1
		defaults write com.apple.terminal "Default Window Settings" -string "Homebrew"
		defaults write com.apple.terminal "Startup Window Settings" -string "Homebrew"
    fi

	#Installing VMWare Graphics Driver
	printf "Do you want to install the VMWare graphics driver? [y/n]: "
	read answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		echo "Downloading graphics driver..."
		mkdir tempdir
		mount_smbfs //devfiles/QA/KyleS/VM_Files/MacGraphicsDriver tempdir
		cp tempdir/VMsvga2_v1.2.5_OS_10.6-10.8.pkg /Users/$c_username/Desktop
		sleep 5
		umount tempdir
		rmdir tempdir
		echo "Installing graphics driver..."
		open /Users/$c_username/Desktop/VMsvga2_v1.2.5_OS_10.6-10.8.pkg
	fi
	#if user did not install driver AND installed aliases,
	#quit Mac terminal to apply aliases
	if [ "$al_answer" = "y" ] || [ "$al_answer" = "Y" ] || [ "$defaults_answer" = "y" ] || [ "$defaults_answer" = "Y" ]
	then
		echo "Are you sure you want to close all open terminal windows? [y/n]"
		read answer
		if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
		then
			killall Terminal
		fi
	fi

#########################################
#Linux
else
	#Download Surround
	printf "Do you want to download Surround to the Desktop? [y/n]: "
	read dl_scm_answer
	if [ "$dl_scm_answer" = "y" ] || [ "$dl_scm_answer" = "Y" ]
	then
		# We must have smbfs installed in order to mount camelot
		if [[ ("$distro" = "Ubuntu") || ("$distro" = "Debian") ]]
		then
			apt-get install smbfs -y >> /dev/null
			apt-get install cifs-utils -y >> /dev/null
		fi
		printf "Enter password for $username: "
		read -s password
		echo ""
		mkdir .tempdir >> /dev/null
		if [[ ("$distro" = "Fedora") ]]
		then
			su -c 'mount -t cifs //camelot/UpcomingReleases/SCM .tempdir/ -o username=$username,domain=SEAPINE,password=$password'
		else
			mount -t cifs //camelot/UpcomingReleases/SCM .tempdir/ -o username=$username,domain=SEAPINE,password=$password
		fi
		#clear password
		export password=""

		#Determine the latest version/build
		lastVersion=$(ls .tempdir/ | grep 20 --color=never | tail -n 1)
		lastBuild=$(ls .tempdir/2014.1.0 | grep build --color=never | tail -n 1)

		echo "Do you want to download the latest version($lastVersion  $lastBuild)? [y/n]: "
		read dl_latest_scm_answer
		if [ "$dl_latest_scm_answer" = "y" ] || [ "$dl_latest_scm_answer" = "Y" ]
		then
			release=$lastVersion
			build=$lastBuild
		else
			echo "Release Versions"
			echo "================"
			ls .tempdir/ | grep 20 --color=never
			printf "Enter the release version [$lastVersion]: "
			read release
			release=${release:-$lastVersion}
			echo "Build Numbers"
			echo "============="
			y=0
			list=$(ls .tempdir/$release | grep build --color=never)
			for x in $list
			do
				echo $x
				y=$(($y+1))
			done
			lastBuildNum=$(($y))
			printf "Enter the build number [$lastBuildNum]: "
			read buildnum
			buildnum=${buildnum:-$lastBuildNum}
			build="build$buildnum"
		fi
		echo ""
		echo "Downloading Surround SCM $release $build"
		mkdir /home/$c_username/Desktop/Surround >> /dev/null
		mkdir /home/$c_username/Desktop/Surround/$build >> /dev/null
		cp .tempdir/$release/$build/sscmlinuxinstall.tar.gz /home/$c_username/Desktop/Surround/$build
		umount .tempdir
		rmdir .tempdir
		echo "Extracting sscmlinuxinstall.tar.gz"
		tar -xf /home/$c_username/Desktop/Surround/$build/sscmlinuxinstall.tar.gz -C /home/$c_username/Desktop/Surround/$build
		chown $c_username /home/$c_username/Desktop/Surround/$build
		chgrp $c_username /home/$c_username/Desktop/Surround/$build
		echo "SCM install directory: /home/$c_username/Desktop/Surround/$build"
	fi

	#Download TestTrack
	printf "Do you want to download TestTrack to the Desktop? [y/n]: "
	read dl_tt_answer
	if [ "$dl_tt_answer" = "y" ] || [ "$dl_tt_answer" = "Y" ]
	then
		# We must have smbfs installed in order to mount camelot
		if [[ ("$distro" = "Ubuntu") || ("$distro" = "Debian") ]]
		then
			apt-get install smbfs -y >> /dev/null
			apt-get install cifs-utils -y >> /dev/null
		fi
		printf "Enter password for $username: "
		read -s password
		echo ""
		mkdir .tempdir >> /dev/null
		if [[ ("$distro" = "Fedora") ]]
		then
			su -c 'mount -t cifs //camelot/UpcomingReleases/TestTrack/ .tempdir/ -o username=$username,domain=SEAPINE,password=$password'
		else
			mount -t cifs //camelot/UpcomingReleases/TestTrack/ .tempdir/ -o username=$username,domain=SEAPINE,password=$password
		fi
		#clear password
		export password=""

		#Determine the latest version/build
		lastVersion=$(ls .tempdir/ | grep TTPro_20 --color=never | cut -b 7- | tail -n 1)
		list=$(ls -d .tempdir/TTPro_2014.1.0/Build_?? | grep Build --color=never | cut -b 31-)
		y=0
		for x in $list
		do
			y=$(($y+1))
		done
		lastBuild=$(($y+1))

		printf "Do you want to download the latest version($lastVersion build $lastBuild)? [y/n]: "
		read dl_latest_tt_answer
		if [ "$dl_latest_tt_answer" = "y" ] || [ "$dl_latest_tt_answer" = "Y" ]
		then
			release="TTPro_$lastVersion"
			buildnum=$lastBuild		#Used for cp function below
			build="Build_$lastBuild"
		else

			echo "Release Versions"
			echo "================"
			ls .tempdir/ | grep TTPro_20 --color=never | cut -b 7-
			printf "Enter the release version [$lastVersion]: "
			read nRelease
			nRelease=${release:-$lastVersion}
			release="TTPro_$nRelease"
			echo "Build Numbers"
			echo "============="
			ls -d .tempdir/TTPro_2014.1.0/Build_?? | grep Build --color=never | cut -b 31-
			echo "$lastBuild"
			printf "Enter the build number [$lastBuild]: "
			read buildnum
			buildnum=${buildnum:-$lastBuild}
			if [[ $buildnum -lt 10 ]]
			then
				hasZero=$(echo $buildnum | grep -c 0)
				if [[ $hasZero -eq 0 ]]
				then
					build="Build_0$buildnum"
				else
					build="Build_$buildnum"
				fi
			else
				build="Build_$buildnum"
			fi
		fi
		filename="ttlinuxinstall_$build.tar.gz"
		echo ""
		echo "Downloading TestTrack $nRelease $build"
		mkdir /home/$c_username/Desktop/TestTrack >> /dev/null
		mkdir /home/$c_username/Desktop/TestTrack/$build >> /dev/null
		if [[ ("$buildnum" = "$lastBuild") ]]
		then
			cp .tempdir/$release/$filename /home/$c_username/Desktop/TestTrack/$build
		else
			cp .tempdir/$release/$build/$filename /home/$c_username/Desktop/TestTrack/$build
		fi
		umount .tempdir
		rmdir .tempdir
		echo "Extracting $filename"
		tar -xf /home/$c_username/Desktop/TestTrack/$build/$filename -C /home/$c_username/Desktop/TestTrack/$build
		chown $c_username /home/$c_username/Desktop/TestTrack/$build
		chgrp $c_username /home/$c_username/Desktop/TestTrack/$build
		echo "TT install directory: /home/$c_username/Desktop/TestTrack/$build"
	fi


	# Only ask if setup1.6.sh exists
	setup="setup1.6.sh"
	if [ -f $setup ]
	then
		echo ""
		echo "***** setup1.6.sh is now obsolete. *****"
		printf "Do you still want to run setup1.6.sh? [n]: "
		read ans_setup
		ans_setup=${ans_setup:-n}
		if [ "$ans_setup" = "y" ] || [ "$ans_setup" = "Y" ]
		then
			bash $setup
		fi
	fi
	# If aliases were added and the setup script was ran,
	if [ "$al_answer" = "y" ] || [ "$al_answer" = "Y" ] || [ "$ans_setup" = "y" ] || [ "$ans_setup" = "Y" ]
	then
		#quit Linux terminal to apply aliases
		printf "Are you sure you want to close all open terminal windows? [y/n]: "
		read answer
		if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
		then
			if [ "$distro" = "Fedora" ]
			then
				killall Konsole
			else
				killall gnome-terminal
			fi
		fi
	fi
echo "Finished!"
fi
