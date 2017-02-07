@echo off
IF "%1" == "install" (
	echo|set /p=Installing Wireshark to %WIRESHARK_HOME% . 
	Wireshark-win64-1.12.8.exe /S
	echo done
)
IF "%1" == "uninstall" (
	echo|set /p=Uninstalling Wireshark . 
	"C:\Program Files\Wireshark\uninstall.exe" /S
	echo done
)

