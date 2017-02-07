@echo off
IF "%1" == "install" (
	echo START INSTALL >> atf_droid.log
	rem installer_r24.4.1-windows.exe /S /D=C:\ta\droid
	rem installs per default "for current user only" and ignores the D option
	rem silent install NOT supported
	rem
	rem In case of problems, delete everything under \ta\droid\sdk
	rem and run manual install with: installer_r24.4.1-windows.exe
	rem Follow the below instructions
	rem - install for all users 
	rem - install to directory: %ANDROID_HOME%
	rem - do not start SDK manager at the end of the installation
	echo|set /p=Installing Android SDK .
	7z x -y -o\ta\droid droid_sdk.zip  							 >> atf_droid.log & echo|set /p=.
	rem unzip droid\sdk.zip -d \ta  							 >> atf_droid.log & echo|set /p=.
	rem mkdir %ANDROID_ROOT%                                 >> atf_droid.log 2>&1 & echo|set /p=.
	rem cp -Rpfv .\droid\* %ANDROID_ROOT% 				     >> atf_droid.log & echo|set /p=.
	echo done
	echo|set /p=Installing android packages .
	rem http://stackoverflow.com/questions/17963508/how-to-install-android-sdk-build-tools-on-the-command-line
	call android list sdk --all > droid_sdk_packages.txt & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*23" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*25" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*24" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*22" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*21" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*20" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*19" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Platform-tools.*18" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*25" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*24" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*23" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*22" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*21" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*20" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*19" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Build-tools.*18" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i    >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "SDK Tools"  ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i             >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "USB Driver" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i             >> atf_droid.log 2>&1 & echo|set /p=.
	for /f %%i in ('cat droid_sdk_packages.txt ^| egrep "Web Driver" ^| head -1 ^| cut -d "-" -f1') do echo y | call android update sdk -u -a -t %%i             >> atf_droid.log 2>&1 & echo|set /p=.
	echo done
	echo INSTALL FINISHED >> atf_droid.log
)
IF "%1" == "uninstall" (
	echo START UNINSTALL >> atf_droid.log
	echo Uninstalling Android SDK and packages
	echo|set /p=Deleting everything under \ta\droid\ .
	adb kill-server           >> atf_droid.log 2>&1 & echo|set /p=.
	rem not using env variables because "rm -rf" in a wrong place does proper damage
	rmdir /S /Q \ta\droid     >> atf_droid.log 2>&1 & echo|set /p=.
	rem rm -rf \ta\droid\*        >> atf_droid.log 2>&1 & echo|set /p=.
	echo done
	rem if the installer was used run:
	rem c:\ta\droid\sdk\uninstall.exe /S
	echo UNINSTALL FINISHED >> atf_droid.log
)

