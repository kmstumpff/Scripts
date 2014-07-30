#!/bin/bash
####################################################################################################
# Linux Setup Script
####################################################################################################
#
#*************************************************************************************************
# Table of contents
#*************************************************************************************************
# 1. Purpose
#    a. Addtional Functionality
# 2. Description
# 3. Versions
# 4. Setup and Running the Script
# 5. Known Issues
# 6. Reporting issues with the script
#
#
#*************************************************************************************************
#1. PURPOSE:
#This Script file is designed to install all known missing dependancies
#The purpose of this script is to determine the OS being used and then 
#install the dependencies for that OS. 
#
#	a. Addtional functionality:
#		Additional functionality has been added to this script. 
#		In addition to  missing library installation this script 
#		will also install usefull programs (such as firefox, and chrome).
#		This script also sets up apache and sshd.
#
#
#*************************************************************************************************
#2. DESCRIPTION:
#Determine the OS being used
#Install libaries based upon that OS
#Create a Log file in the /home/seapine directory
#
#NOTE!!: (This only takes Distro into account not version, some files may not be installed
#         because they are not required for that version. Also this is meant as a helper 
#         tool, not an all inclusive script that solves all issues. If anything is missing
#	  	  please email rileym@seapine.com with the issues faced. Thank you. 
#
#
#*************************************************************************************************
#3. VERSIONS:
#
# Version 1.1 
# Updated "New Host Name" Line to point to new host name instead of localhost.localdomain
# 		This will take the distrobution name "CentOS" and add a 2 digit random number such 
#		as CentOS34, and apply this as the new host name.
# Updated CentOS section to include --skip-broken for 64 bit CentOS library installations
#
# Version 1.2
# Fixed some issues to the changes in Version 1.1 dealing with changing the host name
#
# Version 1.3 
# Updated Debian setup section to include Chrome and Firefox 20.0 installations
# This also included the removal of Iceweasel browser for Debian 6
#
# Version 1.4 
# This included the installation of Chrome on Fedora (mainly for Fedora 14 which will not update
# Firefox past version 3.6 (Firefox 3.6 is not supported for Test Track 2013.1.0)
#
# Version 1.5 
# Correcting some grammatical errors. Corrected the CentOS HostName output for the log. It now
# displays the new host name instead of the old one. Addressed issues with Debian 7 and firefox
# browser installation. Firefox 21.0 is now installed while iceweasel is removed. Added code to 
# get 64/32 bit firefox browser for Debian depending upon the version (x86_64 vs i686). Chrome 
# will no longer be installed via this script. If needed please install manually.
#
# Version 1.6
# Includes the name change for the script file from setupLib*.*.sh to setup*.*.sh. The Script 
# covers more than just library installation as of version 1.3 so this better represents the
# functionallity of the script. This version also corrects the issue encountered when setting up
# Debian 6/7. The removal and install of firefox worked until firefox 22 came out. now that the 
# newest browser release has come the changed path caused firefox not to install. This has been
# corrected and a better path has been used. now firefox 22 will be installed, regardless of 
# future firefox releases.
#
#
#*************************************************************************************************
#4. SETUP AND RUNNING THE SCRIPT
#
# Steps:
# 1. Get the setupLib*.*.sh script from surround located (replace * with the newest version number)
# here: sscm://pendragon.seapine.com:4994//SSQA//SSQA/Test%20Scripts/setupLib.zip
# 2. Get this file to the linux VM you are using 
#			a. Place the zipped file in your dev files folder
#           b. Using samba client 'get' the zipped file
# 3. Once the zipped file is on your linux VM unzip the folder
#			a. 'unzip setupLib.zip'
# 4. Move into the unziped folder
#			a. 'cd setup'
# 5. Give the script the proper permissions to execute
#			a. 'chmod 777 setupLib*.*.sh'
# 6. Execute the script
#			a. './setup*.*.sh'
# 7. The script will reboot when finished
# 8. Any errors please consult the setupLib.log file located here: /home/seapine/setupLib.log
#
#
#*************************************************************************************************
#5. KNOWN ISSUES
# 
# Fedora 14 and CentOS6.4 have both been reported to have issues with network connectivity.
# After consulting VM manager on network status if the issue continues check the chkconfig list
# 		Enter 'chckconfig --list' on a terminal window (may have to do this as root)
#		Check the displayed list for 'irqbalance'. If any of the run levels contain 'on' for 
#		'irqbalance' then you must run the command 'chkconfig irqbalance off'. Follow this 
#       command by rebooting the system using the 'reboot' command. 
# 		Any further issues please see number 6.
#
#
#*************************************************************************************************
#6. REPORTING ISSUES WITH THE SCRIPT
# To Report issues with this script please email a detail description of the issue encountered or
# libraries missing from the OS that the script failed to install to 'rileym@seapine.com'
# 
# Please include:
# 1. Distrobution used and version number
# 2. 32 or 64 bit
# 3. Seapine Software used (Test Track or Surround or both)
# 4. The attached setupLib.log file (found in /home/seapine/ directory)
# 5. Description of issue encountered
#
#
#
###################################################################################################
#################################################################################################
clear

#Make sure user is root
ID=id
if [ `$ID -u` -ne 0 ]; then
   echo "This script must be run as root."
   exit 1
fi
#If user is root, continue...


echo "Determine the Distrobution you are using" >> /home/seapine/setupLib.log
#Determine the OS:
distro=$(head -1 /etc/issue | awk '{print $1}') >> /home/seapine/setupLib.log
echo "You are using:" >> /home/seapine/setupLib.log
echo $distro >> /home/seapine/setupLib.log
#
#
echo "Installing Libraries for:"
echo $distro
#
#Case statement for actions based upon OS type
  case  $distro  in
                CentOS)       
			echo "Installing Libraries for CentOS" >> /home/seapine/setupLib.log
			echo "Install missing 32-bit libraries," >> /home/seapine/setupLib.log
			echo "License Server Libraries," >> /home/seapine/setupLib.log
			echo "and Solobug Libraries." >> /home/seapine/setupLib.log
			yum -y install yum-skip-broken >> /home/seapine/setupLib.log
			yum -y install libz.so.1 --skip-broken >> /home/seapine/setupLib.log
			yum -y install glibc.i686 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libgcc_s.so.1 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libgthread-2.0.so.0 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libfreetype.so.6 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXrender.so.1 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libfontconfig.so.1 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXext.so.6 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXi.so.6 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXrandr.so.2 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXfixes.so.3 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libXcursor.so.1 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libstdc++.so.6 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libICE.so.6 --skip-broken >> /home/seapine/setupLib.log
			yum -y install libSM.so.6 --skip-broken >> /home/seapine/setupLib.log
			echo "disable SELINUX" >> /home/seapine/setupLib.log	        
			sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config >> /home/seapine/setupLib.log
			echo "turning Apache Web Server On" >> /home/seapine/setupLib.log
			chkconfig httpd on >> /home/seapine/setupLib.log
			echo "turning SSH On" >> /home/seapine/setupLib.log
			chkconfig sshd on >> /home/seapine/setupLib.log
			echo chkconfig --list >> /home/seapine/setupLib.log 
			echo "Checking Host Name..." >> /home/seapine/setupLib.log
				hostname >> /home/seapine/setupLib.log
			echo "Setting Host Name to Unique variable..." >> /home/seapine/setupLib.log
				initials="ks" >> /home/seapine/setupLib.log
				hname=($initials"-"$distro) >> /home/seapine/setupLib.log
				hname=${hname,,} >> /home/seapine/setupLib.log
				oldname=$(hostname) >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/sysconfig/network >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hosts >> /home/seapine/setupLib.log			
				echo "New Host Name:" >> /home/seapine/setupLib.log
				hostname  >> /home/seapine/setupLib.log
			echo "New Host Name:"
			echo $(hname)
			echo "Rebooting..." >> /home/seapine/setupLib.log
			echo "Rebooting..."
			reboot >> /home/seapine/setupLib.log
                    ;;
                Fedora)
                        echo "Installing Libraries for Fedora" >> /home/seapine/setupLib.log
			echo "Installing libaio for Oracle" >> /home/seapine/setupLib.log
			yum -y install libaio-devel >> /home/seapine/setupLib.log
			echo "Setting up chkconfig irqbalance" >> /home/seapine/setupLib.log
			chkconfig irqbalance off >> /home/seapine/setupLib.log
			echo "Start Apache upon reboot" >> /home/seapine/setupLib.log
			chkconfig httpd on >> /home/seapine/setupLib.log
			echo "disable SELINUX" >> /home/seapine/setupLib.log	        
			sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config >> /home/seapine/setupLib.log
			echo "turning Apache Web Server On" >> /home/seapine/setupLib.log
			chkconfig httpd on >> /home/seapine/setupLib.log
			echo "turning SSH On" >> /home/seapine/setupLib.log
			chkconfig sshd on >> /home/seapine/setupLib.log
			echo chkconfig --list >> /home/seapine/setupLib.log 
			echo "Checking Host Name..." >> /home/seapine/setupLib.log
				hostname >> /home/seapine/setupLib.log
			echo "Setting Host Name to Unique variable..." >> /home/seapine/setupLib.log
				initials="ks" >> /home/seapine/setupLib.log
				hname=($initials"-"$distro) >> /home/seapine/setupLib.log
				hname=${hname,,} >> /home/seapine/setupLib.log
				oldname=$(hostname) >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hostname >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hosts >> /home/seapine/setupLib.log
				echo "New Host Name:" >> /home/seapine/setupLib.log
			hname  >> /home/seapine/setupLib.log
			echo "New Host Name:"
			echo $(hname)
			echo "Rebooting..."
			echo "Rebooting..." >> /home/seapine/setupLib.log
			reboot >> /home/seapine/setupLib.log

                    ;; 
                Welcome)
                        echo "Installing Libraries for OpenSuse" >> /home/seapine/setupLib.log
                        echo "Installing Missing Libraries (First List may already be installed)" >> /home/seapine/setupLib.log
                        zypper -non-interactive install libgthread-2.0.so.0 >> /home/seapine/setupLib.log
			zypper -non-interactive install libfreetype.so.6 >> /home/seapine/setupLib.log
                zypper -non-interactive install libgobject-2.0.so.0 >> /home/seapine/setupLib.log
                zypper -non-interactive install libXrender.so.1 >> /home/seapine/setupLib.log
                zypper -non-interactive install libfontconfig.so.1 >> /home/seapine/setupLib.log
                zypper -non-interactive install libXext.so.6 >> /home/seapine/setupLib.log
                zypper -non-interactive install libaio.so.1 >> /home/seapine/setupLib.log
                zypper -non-interactive install libICE.so.6 >> /home/seapine/setupLib.log
                zypper -non-interactive install libSM.so.6 >> /home/seapine/setupLib.log
			echo "Installing Libraries for Solobug" >> /home/seapine/setupLib.log
                zypper -non-interactive install libXi.so.6>> /home/seapine/setupLib.log
                zypper -non-interactive install libXrandr.so.2 >> /home/seapine/setupLib.log
				zypper -non-interactive install libXfixes.so.3 >> /home/seapine/setupLib.log
				zypper -non-interactive install libXcursor.so.1 >> /home/seapine/setupLib.log
				zypper -non-interactive install libXinerama.so.1 >> /home/seapine/setupLib.log
			echo "Checking Apache Status" >> /home/seapine/setupLib.log
			service apache2 status >> /home/seapine/setupLib.log
			echo "Start Apache" >> /home/seapine/setupLib.log
			service apache2 start >> /home/seapine/setupLib.log
			echo "Set Apache to start upon restart" >> /home/seapine/setupLib.log
			chkconfig apache2 on >> /home/seapine/setupLib.log
			chkconfig --list apache2 >> /home/seapine/setupLib.log
			echo "Set SSH to start upon restart" >> /home/seapine/setupLib.log
			chkconfig sshd on >> /home/seapine/setupLib.log
			chkconfig --list apache2 >> /home/seapine/setupLib.log
			echo "Start SSH" >> /home/seapine/setupLib.log
			/etc/init.d/sshd start
			echo "Checking Host Name..." >> /home/seapine/setupLib.log
				hostname >> /home/seapine/setupLib.log
			echo "Setting Host Name to Unique variable..." >> /home/seapine/setupLib.log
				initials="ks" >> /home/seapine/setupLib.log
				hname=($initials"-opensuse") >> /home/seapine/setupLib.log
				hname=${hname,,} >> /home/seapine/setupLib.log
				oldname=$(hostname) >> /home/seapine/setupLib.log				
				sed -i s/"$oldname"/"$hname"/g /etc/HOSTNAME >> /home/seapine/setupLib.log
				#sed -i s/"$oldname"/"$hname"/g /etc/hosts >> /home/seapine/setupLib.log
			echo "New Host Name:" >> /home/seapine/setupLib.log
			hostname  >> /home/seapine/setupLib.log	
			echo "New Host Name:"
			echo $(hname)
			echo "Rebooting..."
			echo "Rebooting..." >> /home/seapine/setupLib.log
			reboot >> /home/seapine/setupLib.log			
			;;                       
		Debian)
			#Determine the bit version (32/64 bit)
			echo "Installing Oracle Dependancies for Debian" >> /home/seapine/setupLib.log
			apt-get -y install libaio-dev
			echo "apt-get update to fix missing libraries" >> /home/seapine/setupLib.log
			apt-get -y update >> /home/seapine/setupLib.log
			echo "Installing and starting sshd" >> /home/seapine/setupLib.log
			apt-get -y install openssh-server >> /home/seapine/setupLib.log
			echo "Removing Ice Weasel Browser and Installing Firefox 21.0..."
			echo "Removing Ice Weasel Browser and Installing Firefox 21.0..." >> /home/seapine/setupLib.log
			cd /home/seapine/Downloads	
			echo "Checking for 32/64 bit version of Debian" 
			echo "Checking for 32/64 bit version of Debian" >> /home/seapine/setupLib.log
			version=$(uname -a | awk '{print $8}') >> /home/seapine/setupLib.log
			echo "You are using a framework of: "  >> /home/seapine/setupLib.log
			echo $version >> /home/seapine/setupLib.log
			cd /home/seapine/Downloads  >> /home/seapine/setupLib.log
			echo "Check 32/64 version and get firefox for that version" >> /home/seapine/setupLib.log
			if [ "$version" == "x86_64" ]; then
				echo "Getting 64 bit installer" >> /home/seapine/setupLib.log
				wget 'http://mozilla.mirrors.tds.net/pub/mozilla.org/firefox/releases/22.0/linux-x86_64/en-US/firefox-22.0.tar.bz2'  >> /home/seapine/setupLib.log
			else
				echo "Getting 32 bit installer" >> /home/seapine/setupLib.log 
				wget 'http://mozilla.mirrors.tds.net/pub/mozilla.org/firefox/releases/22.0/linux-i686/en-US/firefox-22.0.tar.bz2'  >> /home/seapine/setupLib.log
			fi
			echo "Remove IceWeasel"  >> /home/seapine/setupLib.log
			apt-get -y remove iceweasel >> /home/seapine/setupLib.log
			mv firefox-22.0.tar.bz2 /usr/lib >> /home/seapine/setupLib.log
			cd /usr/lib >> /home/seapine/setupLib.log	
			tar -jxvf firefox-22.0.tar.bz2 >> /home/seapine/setupLib.log
			ln -s /usr/lib/firefox/firefox /usr/bin/firefox >> /home/seapine/setupLib.log
			echo "Checking Host Name..." >> /home/seapine/setupLib.log
				hostname >> /home/seapine/setupLib.log
			echo "Setting Host Name to Unique variable..." >> /home/seapine/setupLib.log
				initials="ks" >> /home/seapine/setupLib.log
				hname=($initials"-"$distro) >> /home/seapine/setupLib.log
				hname=${hname,,} >> /home/seapine/setupLib.log
				oldname=$(hostname) >> /home/seapine/setupLib.log				
				sed -i s/"$oldname"/"$hname"/g /etc/hostname >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hosts >> /home/seapine/setupLib.log
			echo "New Host Name:" >> /home/seapine/setupLib.log
			hostname  >> /home/seapine/setupLib.log	
			echo "New Host Name:"
			echo $(hname)
			echo "Rebooting..."
			echo "Rebooting..." >> /home/seapine/setupLib.log
			reboot >> /home/seapine/setupLib.log			
		    ;;
               Ubuntu)       
                        echo "Installing Oracle Dependancies for Ubuntu" >> /home/seapine/setupLib.log
			apt-get -y install libaio-dev >> /home/seapine/setupLib.log	
			echo "Installing and starting sshd" >> /home/seapine/setupLib.log
			apt-get -y install openssh-server >> /home/seapine/setupLib.log
			echo "turning Apache Web Server On" >> /home/seapine/setupLib.log
			service apache2 start >> /home/seapine/setupLib.log
			service apache2 status >> /home/seapine/setupLib.log
			echo "Installing GNOME desktop environment" >> /home/seapine/setupLib.log
			sudo add-apt-repository -y ppa:gnome3-team/gnome3 >> /home/seapine/setupLib.log
			sudo apt-get -y update >> /home/seapine/setupLib.log
			sudo apt-get -y upgrade >> /home/seapine/setupLib.log
			sudo apt-get -y install gnome-shell >> /home/seapine/setupLib.log
			echo "Checking Host Name..." >> /home/seapine/setupLib.log
				hostname >> /home/seapine/setupLib.log
			echo "Setting Host Name to Unique variable..." >> /home/seapine/setupLib.log
				initials="ks" >> /home/seapine/setupLib.log
				hname=($initials"-"$distro) >> /home/seapine/setupLib.log
				hname=${hname,,} >> /home/seapine/setupLib.log
				oldname=$(hostname) >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hostname >> /home/seapine/setupLib.log
				sed -i s/"$oldname"/"$hname"/g /etc/hosts >> /home/seapine/setupLib.log
			echo "New Host Name:" >> /home/seapine/setupLib.log
			hname  >> /home/seapine/setupLib.log	
			echo "New Host Name:"
			echo $(hname)
			echo "Rebooting..."
			echo "Rebooting..." >> /home/seapine/setupLib.log
			sleep 2
			reboot >> /home/seapine/setupLib.log			
                    ;;
                *)              
          esac 

echo "done!"
echo "done!" >> /home/seapine/setupLib.log
