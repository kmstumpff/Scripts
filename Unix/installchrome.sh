#!/bin/bash

#Make sure user is root
ID=id
if [ `$ID -u` -ne 0 ]; then
   echo "This script must be run as root."
   exit 1
fi
#If user is root, continue...
clear
MacInstall() {
chrome_dir=/Users/seapine/Desktop/Chrome
echo "Downloading stable Chrome release to $chrome_dir"
mkdir $chrome_dir
wget https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg -O $chrome_dir/googlechrome.dmg
hdiutil attach -nobrowse -quiet $chrome_dir/googlechrome.dmg
cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/Google\ Chrome.app
echo "Google Chrome is installed"
hdiutil detach -quiet /Volumes/Google\ Chrome/
}

osname=$(uname -s)

if [ "$osname" = "Linux" ]
then
	#Determine the distro of Linux:
	echo "Determining the distribution you are using" 
	distro=$(head -1 /etc/issue | awk '{print $1}')
	echo "You are using:"
	echo $distro
	case	$distro	in
			CentOS)
			#Update repositories
			yum update
			#Install Google Chrome
			osproc=$(uname -p) 
			if [ $osproc = "x86_64" ]
			then
				yum install -y libstdc++-devel.x86_64
				yum localinstall --nogpgcheck --skip-broken -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			else
				yum localinstall --nogpgcheck --skip-broken -y https://dl.google.com/linux/direct/google-chrome-stable_current_i386.rpm
			fi
			;;
			Fedora)
			#Update repositories
			yum update
			#Install Google Chrome
			osproc=$(uname -p) 
			if [ $osproc = "x86_64" ]
				then
				yum localinstall --nogpgcheck -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
				else
				yum localinstall --nogpgcheck -y https://dl.google.com/linux/direct/google-chrome-stable_current_i386.rpm
			fi
			;;
			Debian)
			#Update repositories
			apt-get update
			#Install Google Chrome
			apt-get install -y gdebi-core
			osproc=$(uname -p) 
			if [ $osproc = "x86_64" ]
				then
				#Download
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
				#Install
				gdebi /tmp/google-chrome-stable_current_amd64.deb
				#Cleanup
				rm /tmp/google-chrome-stable_current_amd64.deb
				else
				#Download
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -O /tmp/google-chrome-stable_current_i386.deb
				#Install
				gdebi /tmp/google-chrome-stable_current_i386.deb
				#Cleanup
				rm /tmp/google-chrome-stable_current_i386.deb
			fi
			;;
			Ubuntu)
			#Update repositories
			apt-get update
			#Install Google Chrome
			apt-get install -y gdebi-core
			osproc=$(uname -p) 
			if [ $osproc = "x86_64" ]
				then
				#Download
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
				#Install
				gdebi /tmp/google-chrome-stable_current_amd64.deb
				#Cleanup
				rm /tmp/google-chrome-stable_current_amd64.deb
				else
				#Download
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb -O /tmp/google-chrome-stable_current_i386.deb
				#Install
				gdebi /tmp/google-chrome-stable_current_i386.deb
				#Cleanup
				rm /tmp/google-chrome-stable_current_i386.deb
			fi
			;;
			Welcome)
			if [ $osproc = "x86_64" ]
				then
				#Add repository
				zypper ar http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
				else
				zypper ar http://dl.google.com/linux/chrome/rpm/stable/i386 Google-Chrome
			fi
			zypper ref
			#install Google Chrome
			zypper in google-chrome-stable
			;;
			*)
			echo "Not Supported"
			;;
			esac
elif [ "$osname" = "Darwin" ]
then
	# Install for Mac
	# Is Homebrew AND wget installed?
	path_brew=$(which brew)
	path_wget=$(which wget)
	if [ -f "$path_wget" ]
	then
		MacInstall
	elif [ -f "$path_brew" ]
		echo "Wget not found."
		sudo -u seapine brew install wget
		echo "wget installed."
		MacInstall
	else
		echo "Homebrew not found. Installing Homebrew and wget..."
		sudo -u seapine ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
		sudo -u seapine brew doctor
		sudo -u seapine brew install wget
		echo "Homebrew and wget installed."
		MacInstall
	fi
fi

































