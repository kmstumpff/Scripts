@ECHO off


rem Get test files off of devfiles
rem ########################################################################################################
echo Downloading files...
mkdir tempdir
attrib +h tempdir
xcopy "\\devfiles\QA\Surround Test Files\Misc Files" tempdir /E > nul
xcopy "\\devfiles\QA\Surround Test Files\Activations\Release1" tempdir /E > nul
copy "\\devfiles\QA\Surround Test Files\SCMServDbfirstandhalf.zip" tempdir > nul
xcopy "\\devfiles\QA\KyleS\VM_Files\samplefiles" tempdir /E > nul
copy \\devfiles\QA\*.jpg tempdir > nul
rem ########################################################################################################



rem #Add files to Surround
rem ########################################################################################################
set /P scm_un=Enter Surround username [Administrator]: 
IF NOT DEFINED scm_un (set scm_un=Administrator)
set /P scm_pw=Enter password [ ]: 
IF NOT DEFINED scm_pw (set scm_pw= )
set /P scm_address=Enter server address [localhost]: 
IF NOT DEFINED scm_address (set scm_address=localhost)
set /P scm_port=Enter port [4900]: 
IF NOT DEFINED scm_port (set scm_port=4900)
set /P scm_mainline=Enter name of mainline [Mainline]: 
IF NOT DEFINED scm_mainline (set scm_mainline=Mainline)
rem #add files to mainline
echo Adding files to Surround mainline: %mainline%
sscm add tempdir\* -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
rem ########################################################################################################

rem #Remove tempdir
rmdir /S /Q tempdir > nul