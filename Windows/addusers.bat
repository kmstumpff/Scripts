@echo off

rem =====  Get SCM info =====
set /P scm_un=Enter Surround username [Administrator]: 
IF NOT DEFINED scm_un (set scm_un=Administrator)
set /P scm_pw=Enter password [ ]: 
IF NOT DEFINED scm_pw (set scm_pw= )
set /P scm_address=Enter server address [localhost]: 
IF NOT DEFINED scm_address (set scm_address=localhost)
set /P scm_port=Enter port [4900]: 
IF NOT DEFINED scm_port (set scm_port=4900)
set /P scm_users=Enter number of users [9]: 
IF NOT DEFINED scm_users (set scm_users=9)
rem =====  Got SCM info =====

for /l %%x in (1, 1, %scm_users%) do (
	echo "Creating user%%x..."
	sscm adduser test%%x -fTest -lUser%%x -w- -ifloating -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
)
sscm addgroup Testers -s"general+all:admin+all:users+all:security groups+all:files+all:branch+all" -yAdministrator -zlocalhost:4900
for /l %%x in (1, 1, %scm_users%) do (
	sscm editgroup Testers -u+test%%x -yAdministrator -zlocalhost:4900
)
echo "Users have been added to security group: Testers"