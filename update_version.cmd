@echo off
SETLOCAL

REM Updates currently only build info!!
REM TODO: version update

REM generate build info string
for /f %%i in ('date /T ^| sed s/\.//g ^| sed s/\///g') do set date=%%i
for /f %%i in ('time /T ^| sed s/\://g') do set time=%%i
for /f %%i in ('git log -1 --date^=format:%%Y%%m%%d%%H%%M --pretty^=_%%h_%%ad') do set commt=%%i
set BLD_INFO=%time%%date%%commt%

REM update lib files with build info
CALL :update_version_string     src\py\ATFCommons\__init__.py
CALL :update_version_string     src\py\DeviceControl\__init__.py
CALL :update_version_string     src\py\Wireshark\__init__.py
CALL :update_version_string     src\py\BrowserControl\__init__.py
GOTO :eof

:update_version_string
SET PY_FILE=%1
for /f "delims=xxx" %%i in ('egrep ROBOT_LIBRARY_BUILD %PY_FILE% ^| cut -d+ -f 1') do set V_LINE=%%i
set NEW_LINE=%V_LINE%+ '%BLD_INFO%'
sed "/ROBOT_LIBRARY_BUILD/c\%NEW_LINE%" %PY_FILE% > %PY_FILE%.sed
mv -f %PY_FILE%.sed %PY_FILE%
GOTO :eof

ENDLOCAL
