#!/bin/bash

#add the find server script to "/usr/bin"
echo "#!/bin/sh
#   
# function to find the pid the license server
pidofspls() {

    ps -ef > /tmp/ps.tbl 2> /dev/null
    pid=`awk -F" " '/\/splicsvr/ {print $2}' /tmp/ps.tbl`
	rm -rf /tmp/ps.tbl > /dev/null 2>&1
    if [ "$pid" != "" ]
    then 
        echo $pid
        return 0 
    fi
}
   
#function to find the pid of the surround server
pidofsurroundscm() {

    ps -ef > /tmp/ps.tbl 2> /dev/null
    pid=`awk -F" " '/\/scmserver/ {print $2}' /tmp/ps.tbl`
	rm -rf /tmp/ps.tbl > /dev/null 2>&1
    if [ "$pid" != "" ]
    then 
        echo $pid
        return 0 
    fi
}
pidls=`pidofspls $1`
pidss=`pidofsurroundscm $1`

#Output the results
if [ "$pidls" != "" ]
then
    echo "The license server is running!"
    echo "The pid of spls is: $pidls"
else
    echo "The license server is not running!"
fi

echo ""

if [ "$pidss" != "" ]
then
    echo "The surround server is running!"
    echo "The pid of surroundscm is: $pidss"
else
    echo "The surround server is not running!"
fi
echo """ >> /usr/bin/fs

echo "alias lsadmin='cd /Applications/Seapine\ License\ Server/Seapine\ License\ Server\ Admin\ Utility.app/Contents/MacOS; ./Seapine\ License\ Server\ Admin'" >> /etc/bashrc

echo "alias scmgui='cd /Applications/Surround\ SCM/Surround\ SCM\ Client.app/Contents/MacOS/;./Surround\ SCM'" >> /etc/bashrc

echo "alias la='ls -lah'" >> /etc/bashrc

echo "alias ll='ls -lh'" >> /etc/bashrc

echo "alias cd..='cd ..'"  >> /etc/bashrc

killall Terminal