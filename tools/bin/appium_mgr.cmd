@echo off
SETLOCAL
IF [%1]==[]   SET ACTION=start
if NOT defined ACTION (
    SET ACTION=%1
)
IF "%ACTION%" == "start" (
    CALL  :start_appium
)
IF "%ACTION%" == "stop" (
    CALL  :stop_appium
)
IF "%ACTION%" == "restart" (
    CALL  :stop_appium
    CALL  :start_appium
)
GOTO :eof

:start_appium
echo|set /p=Starting Appium ..
Call run_appium.cmd
echo  done
GOTO :eof

:stop_appium
echo Closing all Appium console windows: 
taskkill /FI "WINDOWTITLE eq appium:*"
echo Done
GOTO :eof