@echo off
IF "%1" == "install" (
	echo START INSTALL >> atf_pycharm.log
	echo|set /p=Installing PyCharm .
	rem pycharm-community-4.5.4.exe /S                 >> atf_pycharm.log & echo|set /p=.
	pycharm-community-5.0.4.exe /S                 >> atf_pycharm.log & echo|set /p=.
	rem cp -fpR .PyCharm40 %USERPROFILE%           >> atf_pycharm.log & echo|set /p=.
	rem 7z x -y -o%USERPROFILE% PyCharm40_profile.zip  >> atf_pycharm.log & echo|set /p=.
	rem cp -fpR .PyCharm40 %USERPROFILE%           >> atf_pycharm.log & echo|set /p=.
	7z x -y -o%USERPROFILE% PyCharm50_profile.zip  >> atf_pycharm.log & echo|set /p=.
	echo done
	echo STOP INSTALL >> atf_pycharm.log
)
IF "%1" == "uninstall" (
	echo START UNINSTALL >> atf_pycharm.log
	echo|set /p=Uninstalling PyCharm .
	"c:\Program Files\JetBrains\PyCharm Community Edition 4.5.4\bin\Uninstall.exe" /S     >> atf_pycharm.log & echo|set /p=.
	rem remove also user profile stuff
	rem rmdir /S /Q %USERPROFILE%\.PyCharm40                                                    >> atf_pycharm.log & echo|set /p=.
	rem rm -fr %USERPROFILE%\.PyCharm40\* 														>> atf_pycharm.log & echo|set /p=.
	echo STOP UNINSTALL >> atf_pycharm.log
	echo done
)

