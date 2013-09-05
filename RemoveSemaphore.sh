#!/bin/sh
##################################################################
# This Script is used to remove the semaphore from Seapine
# servers that do not shut down properly and will not restart.
# It asks for the specific server to cleanup, then clears the 
# appropriate semaphore set. The script loops until user selects
# exit.
##################################################################

#---------------------------
# Display a menu
#---------------------------
clear
while [ "$rs_answer" != "5" ]
do
	echo "Which server need to be cleaned up?"
	echo "[1] - License Server"
	echo "[2] - Surround SCM Server"
	echo "[3] - Surround SCM Proxy Server"
	echo "[4] - TestTrack Server"
	echo "[5] - Exit"
	read rs_answer
	clear
	#---------------------------
	# Clean up selected server
	#---------------------------

	if [ "$rs_answer" = "1" ]
	then
		echo "Fixing the License Server..."
		if ipcrm -S 0x07541653
		then echo "Fixed"
		else echo "Nothing to clean up"
		fi
	fi
	if [ "$rs_answer" = "2" ]
	then
		echo "Fixing the Surround SCM Server..."
		if ipcrm -S 0x07541654
		then echo "Fixed"
		else echo "Nothing to clean up"
		fi
	fi
	if [ "$rs_answer" = "3" ]
	then
		echo "Fixing the Surround SCM Proxy Server..."
		if ipcrm -S 0x07541652
		then echo "Fixed"
		else echo "Nothing to clean up"
		fi
	fi
	if [ "$rs_answer" = "4" ]
	then
		echo "Fixing the TestTrack Server..."
		if ipcrm -S 0x0754165
		then echo "Fixed"
		else echo "Nothing to clean up"
		fi
	fi
echo ""
done
clear
