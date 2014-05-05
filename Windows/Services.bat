@echo off

goto check_Permissions

:check_Permissions
net session >nul 2>&1
if %errorLevel% == 0 (
	cls
	GOTO Options
) else (
    echo Failure: Must run command prompt as administrator.
	echo Error: %errorLevel%
	pause
	EXIT /B %errorLevel%
)

:Options
echo Select a service to start, stop, or restart...
echo.
echo [1] TestTrack Server
echo [2] Surround Server
echo [3] License Server
echo [4] Quit
echo.
set /P sp_option=Enter an option: 
IF "%sp_option%" == "1" ( GOTO Status_TT
) ELSE IF "%sp_option%" == "2" ( GOTO Status_SCM
) ELSE IF "%sp_option%" == "3" ( GOTO Status_LS
) ELSE IF "%sp_option%" == "4" ( GOTO End
) ELSE ( GOTO WrongOption )

:TestTrack
echo.
echo [1] Start Server
echo [2] Stop Server
echo [3] Restart Server
echo [4] Return to options
echo [5] Quit
echo.
set /P tt_option=Enter an option: 
IF "%tt_option%" == "1" ( net start TestTrackSrv & cls & GOTO Options
) ELSE IF "%tt_option%" == "2" ( net stop TestTrackSrv & cls & GOTO Options
) ELSE IF "%tt_option%" == "3" ( net stop TestTrackSrv & net start TestTrackSrv & cls & GOTO Options
) ELSE IF "%tt_option%" == "4" ( cls & GOTO Options
) ELSE IF "%tt_option%" == "5" ( GOTO End
) ELSE ( GOTO WrongTT )
:Surround
echo.
echo [1] Start Server
echo [2] Stop Server
echo [3] Restart Server
echo [4] Return to options
echo [5] Quit
echo.
set /P scm_option=Enter an option: 
IF "%scm_option%" == "1" ( net start SurroundSCMSrv & cls & GOTO Options
) ELSE IF "%scm_option%" == "2" ( net stop SurroundSCMSrv & cls & GOTO Options
) ELSE IF "%scm_option%" == "3" ( net stop SurroundSCMSrv & net start SurroundSCMSrv & cls & GOTO Options
) ELSE IF "%scm_option%" == "4" ( cls & GOTO Options
) ELSE IF "%scm_option%" == "5" ( GOTO End
) ELSE GOTO WrongSCM
:License
echo.
echo [1] Start Server
echo [2] Stop Server
echo [3] Restart Server
echo [4] Return to options
echo [5] Quit
echo.
set /P ls_option=Enter an option: 
IF "%ls_option%" == "1" ( net start SeapineLicenseSrv & cls & GOTO Options
) ELSE IF "%ls_option%" == "2" ( net stop SeapineLicenseSrv & cls & GOTO Options
) ELSE IF "%ls_option%" == "3" ( net stop SeapineLicenseSrv & net start SeapineLicenseSrv & cls & GOTO Options
) ELSE IF "%ls_option%" == "4" ( cls & GOTO Options
) ELSE IF "%ls_option%" == "5" ( GOTO End
) ELSE ( GOTO WrongLS )
:Status_TT
sc query "TestTrackSrv" | find "RUNNING"
if "%ERRORLEVEL%" == "2" goto tttrouble
if "%ERRORLEVEL%" == "1" goto ttstopped
if "%ERRORLEVEL%" == "0" goto ttstarted
echo unknown status
goto Options
:tttrouble
cls
echo TestTrack Server - trouble
goto TestTrack
:ttstarted
cls
echo TestTrack Server - started
goto TestTrack
:ttstopped
cls
echo TestTrack Server - stopped
goto TestTrack

:Status_SCM
sc query "SurroundSCMSrv" | find "RUNNING"
if "%ERRORLEVEL%" == "2" goto scmtrouble
if "%ERRORLEVEL%" == "1" goto scmstopped
if "%ERRORLEVEL%" == "0" goto scmstarted
echo unknown status
goto Options
:scmtrouble
cls
echo Surround Server - trouble
goto Surround
:scmstarted
cls
echo Surround Server - started
goto Surround
:scmstopped
cls
echo Surround Server - stopped
goto Surround

:Status_LS
sc query "SeapineLicenseSrv" | find "RUNNING"
if "%ERRORLEVEL%" == "2" goto lstrouble
if "%ERRORLEVEL%" == "1" goto lsstopped
if "%ERRORLEVEL%" == "0" goto lsstarted
echo License Server - unknown status
goto Options
:lstrouble
cls
echo License Server - trouble
goto License
:lsstarted
cls
echo License Server - started
goto License
:lsstopped
cls
echo License Server - stopped
goto License

:WrongOption
cls
echo Invalid Input!
echo.
GOTO Options

:WrongTT
cls
echo Invalid Input!
echo.
GOTO Status_TT

:WrongSCM
cls
echo Invalid Input!
echo.
GOTO Status_SCM

:WrongLS
cls
echo Invalid Input!
echo.
GOTO Status_LS

:End
cls