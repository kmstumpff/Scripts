echo batch file for turning remote desktop on
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
echo 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fAllowToGetHelp /t REG_DWORD /d 1 /f
echo. 2> C:\scripts\EmptyFile.txt
echo turn off the firewall
netsh firewall set opmode disable
echo remote desktop on...