@echo off
rem TODO: add plugins
IF "%1" == "install" (
	echo|set /p=Installing Notepad++ . 
	npp.6.8.6.Installer.exe /S
	echo done
)
IF "%1" == "uninstall" (
	echo|set /p=Uninstalling Notepad++ . 
	"c:\Program Files (x86)\Notepad++\uninstall.exe" /S
	echo done
)

