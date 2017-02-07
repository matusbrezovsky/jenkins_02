@echo off
IF "%1" == "install" (
	echo START INSTALL >> atf_cygwin.log
	echo|set /p=Installing Cygwin to C:\cygwin64 .
	for /f %%i in ('pwd') do setup-x86_64.exe -L -l %%i -q       								  >> atf_cygwin.log 2>&1 & echo|set /p=.
	for /f %%i in ('pwd') do setup-x86_64.exe -L -l %%i -q -P openssh							  >> atf_cygwin.log 2>&1 & echo|set /p=.
	echo done
	echo|set /p=Creating user: "ta" for ssh access .
	net user ta ta1234 /add /active:yes /expires:never /fullname:"Test Automation" /comment:"ssh user account - used by the test automation"  >> atf_cygwin.log 2>&1 & echo|set /p=.
	echo done
	echo|set /p=Configuring Firewall for ssh access .
	netsh advfirewall firewall add rule name=SSH dir=in action=allow protocol=tcp localport=22        >> atf_cygwin.log 2>&1 & echo|set /p=.
	echo done
	echo|set /p=Configuring sshd .
	c:\cygwin64\bin\bash --login -c "ssh-host-config -y -c ntsec -u cyg_server -w ta1234"        	  >> atf_cygwin.log 2>&1 & echo|set /p=.
	echo done
	echo Starting sshd
	net start sshd
	echo Installation done
	echo STOP INSTALL >> atf_cygwin.log
)
IF "%1" == "uninstall" (
	echo Automatic uninstall not supported - for manual uninstall see "https://cygwin.com/faq/faq.html#faq.setup.uninstall-all"
	echo exiting
)

rem http://withjames.co.uk/?p=354
rem http://www.windows-commandline.com/add-user-from-command-line/
rem http://www.windows-commandline.com/add-user-to-group-from-command-line/
rem https://cygwin.com/faq/faq.html#faq.setup.uninstall-all
