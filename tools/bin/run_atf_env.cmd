@echo off
rem set TA_GITHOME=C:\git\ta
rem call C:\git\ta\tools\bin\setenv.cmd add
call setenv.cmd add
@echo on
call run_appium.cmd
start "ATF - git" /D %TA_GITHOME% cmd /K git status
start "ATF - adb" /D %TA_GITHOME% cmd /K adb devices -l
sleep 1
start "ATF - log" /D %TA_GITHOME%  cmd /K tail_dbg_log.cmd
start "ATF - console" /D %TA_GITHOME% cmd /K get_atf_versions.cmd
