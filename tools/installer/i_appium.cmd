@echo off
IF "%1" == "install" (
	echo START INSTALL >> atf_appium.log
	echo|set /p=Installing Appium %APPIUM_VERSION% to %APPIUM_HOME% .
	mkdir %APPIUM_ROOT%                                  >> atf_appium.log 2>&1 & echo|set /p=.
	7z x -y -o%APPIUM_ROOT% appium_%APPIUM_VERSION%.zip     >> atf_appium.log & echo|set /p=.
	echo done
	echo STOP INSTALL >> atf_appium.log
)
IF "%1" == "uninstall" (
	echo START UNINSTALL >> atf_appium.log
	echo|set /p=Uninstalling Appium, deleting everything under \ta\appium\%APPIUM_VERSION% .
	rmdir /S /Q \ta\appium\%APPIUM_VERSION% 														>> atf_appium.log & echo|set /p=.
	echo STOP UNINSTALL >> atf_appium.log
	echo done
)
