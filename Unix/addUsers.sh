#!/bin/bash

GetSCMInfo() {
GotInfo=0 # SCM variables have not been set
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
GotInfo=1 # SCM variables have been set
}

echo "Do you want to add test users to Surround? [y/n]: "
read answer
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
        GetSCMInfo
        printf "How many users do you want to add?: "
        read num_users
        for x in $(seq 1 $num_users); do
                #Find if user exists in license server
                lsuser_resp=$(sscm lsuser test$x -g -y$scm_un:$scm_pw -z$scm_address:$scm_port)
                if [ "$resp" ]
                then
                        sscm rtu test$x -y$scm_un:$scm_pw -z$scm_address:$scm_port
                        echo "user$x was retrieved from license server"
                else
                        echo "Creating user$x..."
                        sscm adduser test$x -fTest -lUser$x -w- -ifloating -y$scm_un:$scm_pw -z$scm_address:$scm_port
                fi
        done
        group_resp=$(sscm lsgroup Testers -y$scm_un:$scm_pw -z$scm_address:$scm_port) >> /dev/null
        if [ ! "$group_resp" ]
        then
                sscm addgroup Testers -s"general+all:admin+all:users+all:security groups+all:files+all:branch+all" -y$scm_un:$scm_pw -z$scm_address:$scm_port
        fi
        for x in $(seq 1 $num_users); do
                sscm editgroup Testers -u+test$x -y$scm_un:$scm_pw -z$scm_address:$scm_port
        done
        echo "Users have been added to security group: Testers"
fi

