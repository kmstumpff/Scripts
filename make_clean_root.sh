#!/bin/bash
##########################################################################
#This script removes all files and directories associated with TestTrack,
#Surround, and License Server. It provides a clean environment for
#new installs.
#This script needs to be run as root.
##########################################################################
#Stop all Seapine servers first
surroundscm stop
ttstudio stop
spls stop

#Remove Surround stuff first
rm -rvf /var/lib/SurroundSCM/
rm -vf /var/log/SCMStartup.log
rm -vf /etc/init.d/surroundscm
rm -vf /etc/spscm.conf
rm -vf /usr/bin/surroundscm
rm -vf /usr/bin/surroundscmproxy
rm -vf /usr/bin/scmgui
rm -vf /usr/bin/scmproxyserver
rm -vf /usr/bin/scmserver
rm -vf /etc/init.d/surroundscmproxy
rm -vf /etc/init.d/surroundscm
rm -vf /etc/init.d/rc0.d/*surroundscm
rm -vf /etc/init.d/rc0.d/*surroundscmproxy
rm -vf /etc/init.d/rc1.d/*surroundscm
rm -vf /etc/init.d/rc1.d/*surroundscmproxy
rm -vf /etc/init.d/rc2.d/*surroundscm
rm -vf /etc/init.d/rc2.d/*surroundscmproxy
rm -vf /etc/init.d/rc3.d/*surroundscm
rm -vf /etc/init.d/rc3.d/*surroundscmproxy
rm -vf /etc/init.d/rc4.d/*surroundscm
rm -vf /etc/init.d/rc4.d/*surroundscmproxy
rm -vf /etc/init.d/rc5.d/*surroundscm
rm -vf /etc/init.d/rc5.d/*surroundscmproxy
rm -vf /etc/init.d/rc6.d/*surroundscm
rm -vf /etc/init.d/rc6.d/*surroundscmproxy
#Now remove the TestTrack stuff
rm -rvf /var/lib/TestTrack
rm -vf /usr/bin/ttclient
rm -vf /usr/bin/ttserver
rm -vf /usr/bin/ttstudio
rm -vf /usr/bin/ttregutil
rm -vf /usr/bin/ttadmin
rm -vf /usr/bin/tturlredirector
rm -vf /var/log/Startup.*
rm -vf /etc/ttpro.conf
rm -vf /etc/ttclient.conf
rm -vf /etc/ttstudio.conf
rm -rvf /var/www/htdocs/ttweb
rm -vf /var/www/cgi-bin/ttadmcgi.exe
rm -vf /var/www/cgi-bin/ttcgi.exe
rm -vf /etc/init.d/ttpro
rm -vf /etc/init.d/ttstudio
rm -vf /etc/init.d/rc0.d/*ttpro
rm -vf /etc/init.d/rc0.d/*ttstudio
rm -vf /etc/init.d/rc1.d/*ttpro
rm -vf /etc/init.d/rc1.d/*ttstudio
rm -vf /etc/init.d/rc2.d/*ttpro
rm -vf /etc/init.d/rc2.d/*ttstudio
rm -vf /etc/init.d/rc3.d/*ttpro
rm -vf /etc/init.d/rc3.d/*ttstudio
rm -vf /etc/init.d/rc4.d/*ttpro
rm -vf /etc/init.d/rc4.d/*ttstudio
rm -vf /etc/init.d/rc5.d/*ttpro
rm -vf /etc/init.d/rc5.d/*ttstudio
rm -vf /etc/init.d/rc6.d/*ttpro
rm -vf /etc/init.d/rc6.d/*ttstudio
#Now remove the License Server stuff
rm -rvf /var/lib/splicsvr
rm -vf /var/log/LSStartup.log
rm -vf /usr/bin/lsadmin
rm -vf /usr/bin/spls
rm -vf /usr/bin/splicsvr
rm -vf /etc/splicsvr.conf
rm -vf /etc/init.d/spls
rm -vf /etc/init.d/rc0.d/*spls
rm -vf /etc/init.d/rc0.d/*splicsvr
rm -vf /etc/init.d/rc1.d/*spls
rm -vf /etc/init.d/rc1.d/*splicsvr
rm -vf /etc/init.d/rc2.d/*spls
rm -vf /etc/init.d/rc2.d/*splicsvr
rm -vf /etc/init.d/rc3.d/*spls
rm -vf /etc/init.d/rc3.d/*splicsvr
rm -vf /etc/init.d/rc4.d/*spls
rm -vf /etc/init.d/rc4.d/*splicsvr
rm -vf /etc/init.d/rc5.d/*spls
rm -vf /etc/init.d/rc5.d/*splicsvr
rm -vf /etc/init.d/rc6.d/*spls
rm -vf /etc/init.d/rc6.d/*splicsvr
#Now remove the common files
rm -rvf /usr/lib/seapine
rm -rvf /home/seapine/.seapine
rm -rvf /root/.seapine
#Remove all of TestTrack web
rm -rvf /var/www/html/ttweb
rm -vf /var/www/cgi-bin/tt*
#Now Removing oracle is next
rm -vf /usr/lib/libclntsh.so.10.1                  
rm -vf /usr/lib/libnnz10.so                        
rm -vf /usr/lib/libociei.so 
#Uninstall Postgres
/usr/local/pgsql/uninstall-postgresql
#rm -rvf /usr/local/pgsql
#sudo userdel postgres