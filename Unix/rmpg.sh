#!/bin/bash
#Make sure user is root
export user=$(whoami)
if [ "$user" != "root" ]
then	
	echo "Script must be run as root"
	exit 1
fi 


#Uninstall Postgres
sudo sppostgres stop
if [ -f /usr/local/pgsql/uninstall-postgresql ]; then
    /usr/local/pgsql/uninstall-postgresql
else
	rm -rvf /usr/local/pgsql/data
	rm -vf /usr/bin/sppostgres
	rm -vf /etc/init.d/sppostgres
	rm -vf /usr/bin/pg_dump
	rm -vf /usr/bin/pg_dumpall
	rm -vf /usr/bin/pg_restore
	rm -vf /var/lib/alternatives/pgsql*
	rm -vf /etc/alternatives/pgsql*
	rm -rvf /usr/local/pgsql
	userdel postgres
fi
echo "Press any key to reboot"
read -s -n 1
reboot