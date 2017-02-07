@echo off
IF "%1" == "install" (
	echo START INSTALL >> atf_pip.log
	echo|set /p=updating package managers
	rem pip --upgrade produces errors on win32, these can be ignored
	pip install --upgrade pip==8.1.1                            >> atf_pip.log 2>&1 & echo|set /p=.
	pip install --upgrade setuptools==18.5                      >> atf_pip.log 2>&1 & echo|set /p=.
	pip install wheel==0.26.0                                   >> atf_pip.log 2>&1 & echo|set /p=.
	echo done
	echo|set /p=installing packages
	rem http://www.voidspace.org.uk/python/pycrypto-2.6.1/
	pip install pycrypto-2.6.1-cp27-none-win32.whl              >> atf_pip.log 2>&1 & echo|set /p=.
	rem http://www.lfd.uci.edu/~gohlke/pythonlibs/#lxml
	pip install lxml-3.5.0-cp27-none-win32.whl                  >> atf_pip.log 2>&1 & echo|set /p=.
	pip install robotframework==2.9.2                           >> atf_pip.log 2>&1 & echo|set /p=.
	pip install robotframework-sshlibrary==2.1.2                >> atf_pip.log 2>&1 & echo|set /p=.
	REM pip install robotframework-appiumlibrary==1.3.5             >> atf_pip.log 2>&1 & echo|set /p=.
	echo done
	echo STOP INSTALL >> atf_pip.log
)
IF "%1" == "uninstall" (
	echo START UNINSTALL >> atf_pip.log
	echo|set /p=uninstalling packages 
	echo y | pip uninstall pycrypto==2.6.1 						>> atf_pip.log 2>&1 & echo|set /p=.
	echo y | pip uninstall lxml==3.5.0                          >> atf_pip.log 2>&1 & echo|set /p=.
	echo y | pip uninstall robotframework==2.9.2                >> atf_pip.log 2>&1 & echo|set /p=.
	echo y | pip uninstall robotframework-sshlibrary==2.1.2     >> atf_pip.log 2>&1 & echo|set /p=.
	REM echo y | pip uninstall robotframework-appiumlibrary==1.3.5  >> atf_pip.log 2>&1 & echo|set /p=.
	echo done
	echo STOP UNINSTALL >> atf_pip.log
)

