@echo off
rem *** time only ***
rem set PROMPT=$D$S$T$S$G$S
rem *** date & time only ***
rem set PROMPT=$D$S$T$S$G$S
rem *** [date time[ms] user@path]\n > ***
rem set PROMPT=[$D$S$T$S%USERNAME%@$P\]$_$G$S
rem *** [date time[no-ms] path]\n > ***
set PROMPT=[$D$S$T$H$H$H$S$P\]$_$G$S

rem ****** Windows defaults *******
rem set PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem
set WINPATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
rem set WINPATH=C:\Python27\;"C:\Program Files\Common Files\Microsoft Shared\Windows Live";"C:\Program Files (x86)\Common Files\Microsoft Shared\Windows Live";"C:\Program Files (x86)\Intel\iCLS Client\";"C:\Program Files\Intel\iCLS Client\";%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;"C:\Program Files\Intel\Intel(R) Management Engine Components\DAL";"C:\Program Files\Intel\Intel(R) Management Engine Components\IPT";"C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL";"C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\IPT";"C:\Program Files (x86)\Windows Live\Shared"

set PATH=.\bin;%PATH%

rem ****** reset path ********
if NOT defined OLDPATH (
    rem     set OLDPATH=%PATH%
    rem   We need to remove the git-cheetah part because of git bug (https://github.com/msysgit/msysgit/issues/279)
    rem   and remove + add "'s to all path entries = windows batch cannot deal with spaces in paths
    for /f "tokens=*" %%i in ('path ^| sed "s/C..Program Files .x86..Git.git-cheetah....bin;//g" ^| sed "s/\x22//g" ^| sed "s/;/\x22;\x22/g" ^| sed "s/=/=\x22/" ^| sed "s/$/\x22/" ^| sed "s/PATH=//"') do set OLDPATH=%%i
)


rem ******* Python *******
if NOT defined PYTHONPATH ( 
    set PYTHONPATH=C:\Python27
)
set PATH=%PATH%;%PYTHONPATH%;%PYTHONPATH%\Scripts
set no_proxy=127.0.0.1
REM set https_proxy=https://172.16.1.2:8080
REM set http_proxy=http://172.16.1.2:8080

rem ****** Java Path ********
set JAVA_ROOT=C:\java
set DIST_ROOT=%JAVA_ROOT%\jdk
rem set DIST_ROOT=%JAVA_ROOT%\jre
set JAVA_VERSION=v1.8.0_66
set JAVA_HOME=%DIST_ROOT%\%JAVA_VERSION%
set PATH=%PATH%;%JAVA_HOME%\bin

rem ******* Wireshark *******
if NOT defined WIRESHARK_HOME ( 
    set WIRESHARK_HOME="C:\Program Files\Wireshark"
)
set PATH=%PATH%;%WIRESHARK_HOME%

rem ******* GIT *******
if NOT defined GIT_HOME ( 
    set GIT_HOME="C:\Program Files\Git"
)
set PATH=%PATH%;%GIT_HOME%\bin

rem ******* TA RUNTIME *******
if NOT defined TA_RUNTIME_HOME ( 
	set TA_RUNTIME_HOME=c:\ta
)

rem ******* Android SDK *******
if NOT defined ANDROID_ROOT ( 
	set ANDROID_ROOT=%TA_RUNTIME_HOME%\droid
)
if NOT defined ANDROID_APILEV ( 
    rem set ANDROID_APILEV=18.0.1
    set ANDROID_APILEV=19.1.0
    rem set ANDROID_APILEV=android-4.4W
)
set ANDROID_HOME=%ANDROID_ROOT%\sdk
set PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\build-tools\%ANDROID_APILEV%

rem ******* Appium *******
set APPIUM_ROOT=%TA_RUNTIME_HOME%\appium
rem set APPIUM_VERSION=v1.3.7.2
rem set APPIUM_VERSION=v1.4.13.1
set APPIUM_VERSION=v1.4.16.1
set APPIUM_HOME=%APPIUM_ROOT%\%APPIUM_VERSION%
set PATH=%PATH%;%APPIUM_HOME%

rem ******* Windows *******
set PATH=%PATH%;%OLDPATH%

rem ****** TA path ********
if NOT defined TA_HOME (
    set TA_HOME=c:\git
)
set TA_GITHOME=%TA_HOME%\ta
set TA_TOOLS=%TA_GITHOME%\tools
set PATH=%PATH%;%TA_TOOLS%\bin

