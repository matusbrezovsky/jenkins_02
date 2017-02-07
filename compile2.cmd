@echo off
SETLOCAL

echo Updating Version Tags
call update_version.cmd
REM echo Exporting Python Defs for Cython - works only with mingwpy_win32_vc100
REM cp \Windows\SysWOW64\python27.dll src\bin\
REM pexports src\bin\python27.dll > src\bin\python.def
REM needed only when python version changes
REM dlltool -dllname src\bin\python27.dll --def src\bin\python.def --output-lib src\bin\libpython27.a

echo A T F - C O R E
echo Cythonizing ...
cython -v -D src\cy\atf\utils\base.py           -o src\cy\atf\utils\base.c
cython -v -D src\cy\atf\utils\utils.py          -o src\cy\atf\utils\utils.c
cython -v -D src\cy\atf\utils\list.py           -o src\cy\atf\utils\list.c
cython -v -D src\cy\atf\utils\ui.py             -o src\cy\atf\utils\ui.c
cython -v -D src\cy\atf\device\ctrl.py          -o src\cy\atf\device\ctrl.c
cython -v -D src\cy\atf\traces\wireshark.py     -o src\cy\atf\traces\wireshark.c
cython -v -D src\cy\device_configs_default.py   -o src\cy\device_configs_default.c
cython -v -D src\cy\browser_configs_default.py  -o src\cy\browser_configs_default.c
cython -v -D src\cy\atf\web\ctrl.py             -o src\cy\atf\web\ctrl.c
cython -v -D src\cy\atf\web\po.py               -o src\cy\atf\web\po.c

set GCCARGS=-m32 src\include\libpython27.dll.a src\include\libmsvcr90.a
REM set V=-v
set V=
echo Compiling with gcc ...
echo|set /p=Compiler: 
which gcc.exe
echo gcc arguments: %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\base.pyd           src\cy\atf\utils\base.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\utils.pyd          src\cy\atf\utils\utils.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\list.pyd           src\cy\atf\utils\list.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\ui.pyd             src\cy\atf\utils\ui.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\device\ctrl.pyd          src\cy\atf\device\ctrl.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\traces\wireshark.pyd     src\cy\atf\traces\wireshark.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\device_configs_default.pyd   src\cy\device_configs_default.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\browser_configs_default.pyd  src\cy\browser_configs_default.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\web\ctrl.pyd             src\cy\atf\web\ctrl.c %GCCARGS%  
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\web\po.pyd               src\cy\atf\web\po.c %GCCARGS%  

gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\dongle.pyd       src\cy\atf\utils\dongle.c src\include\libSglW32.a %GCCARGS%
REM compile also into src\cy - otherwise "-P src\cy" executions don't work anymore
gcc %V% -shared -O2 -Ic:\Python27\include -o src\cy\atf\utils\dongle.pyd        src\cy\atf\utils\dongle.c src\include\libSglW32.a %GCCARGS%

echo T O O L I N G
echo Compiling with gcc ...
echo|set /p=Compiler: 
which gcc.exe
echo gcc arguments: %GCCARGS%
REM compile dongle manager
gcc %V% -shared -O2 -Ic:\Python27\include -o src\tools\atftools\lic\dadm.pyd    src\tools\atftools\lic\dadm.c src\include\libSglW32.a %GCCARGS%

echo C L E A N   U P
del src\cy\atf\utils\base.c
del src\cy\atf\utils\utils.c
del src\cy\atf\utils\list.c
del src\cy\atf\utils\ui.c
del src\cy\atf\device\ctrl.c
del src\cy\atf\traces\wireshark.c
del src\cy\device_configs_default.c
del src\cy\browser_configs_default.c
del src\cy\atf\web\ctrl.c
del src\cy\atf\web\po.c
del /S src\bin\*.def
del /S src\bin\*.a
del /S src\bin\*.dll