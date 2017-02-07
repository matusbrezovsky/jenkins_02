@echo off
for /f %%i in ('pwd') do set CURDIR=%%i
SET LOGFILE=%CURDIR%\atf_addons.log

IF "%1" == "install" (
	echo START INSTALL >> %LOGFILE%
	echo Downloading and installing software from git repositories
	REM SET APP_LIB_VER=v1.3.5-2
	SET APP_LIB_VER=v1.3.5-3
	echo|set /p=Appium Library %APP_LIB_VER%
	git clone https://github.com/yahman72/robotframework-appiumlibrary %TA_HOME%\fork-rf-al    >> %LOGFILE% 2>&1 & echo|set /p=.
    cd %TA_HOME%\fork-rf-al                                                                    >> %LOGFILE% 2>&1 & echo|set /p=.
    git checkout tags/%APP_LIB_VER%                                                            >> %LOGFILE% 2>&1 & echo|set /p=.
    python setup.py install                                                                    >> %LOGFILE% 2>&1 & echo|set /p=.
    cd %CURDIR%                                                                                >> %LOGFILE% 2>&1 & echo|set /p=.
	echo done
	REM echo|set /p=Installing Segron Report Templates v2.8.7
	REM cp -f rebot_2.8.7/* C:\Python27\Lib\site-packages\robot\htmldata\rebot                    >> %LOGFILE% 2>&1 & echo|set /p=.
	echo|set /p=Installing Segron Report Templates v2.9.2
	cp -vf rebot_2.9.2/* C:\Python27\Lib\site-packages\robot\htmldata\rebot                    >> %LOGFILE% 2>&1 & echo|set /p=.
	echo done
	echo STOP INSTALL >> %LOGFILE%
)
IF "%1" == "uninstall" (
	echo START UNINSTALL >> %LOGFILE%
	echo !!!  E R R O R  !!!
	echo Automatic uninstall of ATF add-ons NOT supported
	echo Please do the uninstall manually
	echo STOP UNINSTALL >> %LOGFILE%
)

