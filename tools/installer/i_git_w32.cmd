@echo off
IF "%1" == "install" (
	echo|set /p=Installing Git to %GIT_HOME% . 
	Git-2.6.3-32-bit.exe /SILENT /LOADINF="git_inst.cfg"
	echo done
)
IF "%1" == "uninstall" (
	echo|set /p=Uninstalling Git .
	"C:\Program Files\Git\unins000.exe" /SILENT
	echo done
)

