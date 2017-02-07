@echo off
IF "%1" == "install" (
	echo|set /p=installing Java to %JAVA_HOME% .
	for /f %%i in ('pwd') do jdk-8u66-windows-i586.exe INSTALLCFG=%%i\jdk-8u66_inst.cfg /L jdk-8u66_install.log   & echo|set /p=.
	rem jre-8u66-windows-x64.exe INSTALLCFG=C:\ta\dload\jre-8u66_inst.cfg /L jre-8u66_install.log
	echo done
)
IF "%1" == "uninstall" (
	echo|set /p=uninstalling Java .
	msiexec /x {32A3A4F4-B792-11D6-A78A-00B0D0180660} /qn /passive /l* jdk-8u66_uninstall.log
	echo done
)
