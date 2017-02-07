@echo off
IF "%1" == "install" (
	echo|set /p=Installing Python to %PYTHONPATH% .. 
	rem we need 32-bit version because of the pre-compiled crypto libs
	rem msiexec /i python-2.7.10.amd64.msi /passive /norestart /l* python_install.log
	msiexec /i python-2.7.10.msi /passive /norestart /l* python_install.log
	echo done
)
IF "%1" == "uninstall" (
	echo|set /p=Uninstalling Python . 
	rem msiexec /x python-2.7.10.amd64.msi /passive /norestart /l* python_uninstall.log
	msiexec /x python-2.7.10.msi /passive /norestart /l* python_uninstall.log
	echo done
	echo|set /p=removing leftovers in c:\python27\ .. 
	rm -rf C:\Python27\*
	echo done
)

