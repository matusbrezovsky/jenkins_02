@echo off
set ROBOT_SYSLOG_FILE=debug_sys.log
set ROBOT_SYSLOG_LEVEL=DEBUG
for /f %%i in ('pwd') do set LOG_PATH=%%i
echo ATF syslog enabled for this shell - log file: %LOG_PATH%\%ROBOT_SYSLOG_FILE% 
