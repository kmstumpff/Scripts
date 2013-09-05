#!/bin/bash
#This Script file is designed to install all known missing dependancies
#The purpose of this script is to determine the OS being used and then 
#install the dependencies for that OS
#
#
#The script will:
#Determine the OS being used
#Install libaries based upon that OS
#Create a Log file in the /home/seapine directory
#
#NOTE!!: (This only takes Distro into account not version, some files may not be installed
#         because they are not required for that version. Also this is meant as a helper 
#         tool, not an all inclusive script that solves all issues. If anything is missing
#	  please email rileym@seapine.com with the issues faced. Thank you. 
#################################################################################################
clear
#Make sure user is root
ID=id
if [ `$ID -u` -ne 0 ]; then
   echo "This script must be run as root."
   exit 1
fi
#If user is root, continue...

#set some alias' for the terminal
echo "alias la='ls -la'" >> /etc/bachrc

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
			echo "Install missing 32 libraries," >> /home/seapine/setupLib.log
			echo "License Server Libraries," >> /home/seapine/setupLib.log
			echo "and Solobug Libraries." >> /home/seapine/setupLib.log
			yum -y install libz.so.1 >> /home/seapine/setupLib.log
			yum -y install glibc.i686 >> /home/seapine/setupLib.log
			yum -y install libgcc_s.so.1 >> /home/seapine/setupLib.log
			yum -y install libgthread-2.0.so.0 >> /home/seapine/setupLib.log
			yum -y install libfreetype.so.6 >> /home/seapine/setupLib.log
			yum -y install libXrender.so.1 >> /home/seapine/setupLib.log
			yum -y install libfontconfig.so.1 >> /home/seapine/setupLib.log
			yum -y install libXext.so.6 >> /home/seapine/setupLib.log
			yum -y install libXi.so.6 >> /home/seapine/setupLib.log
			yum -y install libXrandr.so.2 >> /home/seapine/setupLib.log
			yum -y install libXfixes.so.3 >> /home/seapine/setupLib.log
			yum -y install libXcursor.so.1 >> /home/seapine/setupLib.log
			yum -y install libstdc++.so.6 >> /home/seapine/setupLib.log
			yum -y install libICE.so.6 >> /home/seapine/setupLib.log
			yum -y install libSM.so.6 >> /home/seapine/setupLib.log
			echo "disable SELINUX" >> /home/seapine/setupLib.log	        
			sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config >> /home/seapine/setupLib.log
			echo "turning SSH On" >> /home/seapine/setupLib.log
			chkconfig sshd on >> /home/seapine/setupLib.log
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
			chkconfig httpd status >> /home/seapine/setupLib.log
			echo "turning SSH On" >> /home/seapine/setupLib.log
			chkconfig sshd on >> /home/seapine/setupLib.log
			echo "Rebooting..."
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
			echo "Start SSH" >> /home/seapine/setupLib.log
			/etc/init.d/sshd start
                    ;;                       
		Debian)
			echo "Installing Oracle Dependancies for Debian" >> /home/seapine/setupLib.log
			apt-get -y install libaio-dev
			echo "Installing and starting sshd" >> /home/seapine/setupLib.log
			apt-get -y install openssh-server >> /home/seapine/setupLib.log
		    ;;
               Ubuntu)       
                        echo "Installing Oracle Dependancies for Ubuntu" >> /home/seapine/setupLib.log
			apt-get -y install libaio-dev >> /home/seapine/setupLib.log	
			echo "Installing and starting sshd" >> /home/seapine/setupLib.log
			apt-get -y install openssh-server >> /home/seapine/setupLib.log
			echo "turning Apache Web Server On" >> /home/seapine/setupLib.log
			service apache2 start >> /home/seapine/setupLib.log
			service apache2 status >> /home/seapine/setupLib.log			
                    ;;
                *)              
          esac 

echo "done!"
echo "done!" >> /home/seapine/setupLib.log
