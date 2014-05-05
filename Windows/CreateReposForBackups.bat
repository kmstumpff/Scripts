@ECHO off

rem #Add files to Surround
rem =====================================================
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
rem =============================================================================================================================================================
echo Adding directory [1 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\ADP --test" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [2 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\Agents" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [3 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\DMX" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [4 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\ICC3_GUI_3.6.X" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [5 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\ICC4" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [6 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\iCERT" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [7 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\INews" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [8 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\ITSamples" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [9 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\MPS" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [10 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\MPS Dedupe" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [11 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\Pike Team" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [12 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\SolWeb_Old" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [13 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\SupportMatrix" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [14 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\TMS" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [15 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\unicode" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [16 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\Utilities" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [17 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\WEB-INF" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [18 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\WFM" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [19 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\WSApplicant_1" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
echo Adding directory [20 of 20]
sscm add "C:\Users\Seapine\Desktop\ForBackups\zz_iModelPrototype" -b%scm_mainline% -c- -p%scm_mainline% -q -r -y%scm_un%:%scm_pw% -z%scm_address%:%scm_port%
rem =============================================================================================================================================================

echo Finished!
rem =====================================================