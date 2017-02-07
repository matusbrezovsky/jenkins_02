@echo off
SETLOCAL

echo Updating Version Tags
call update_version.cmd
echo Exporting Python Defs for Cython
REM works only with mingwpy_win32_vc100
REM should NOT work with python <3.2
REM see https://bitbucket.org/carlkl/mingw-w64-for-python/downloads/mingwpy-2015-04-readme.pdf
REM cp \Windows\SysWOW64\python27.dll src\bin\
pexports \Windows\SysWOW64\python27.dll > src\bin\python.def
dlltool -dllname \Windows\SysWOW64\python27.dll --def src\bin\python.def --output-lib src\bin\libpython27.a

echo A T F - C O R E
echo Cythonizing ...
cython -v -D src\cy\atf\utils\base.py -o src\bin\atf\utils\base.c
cython -v -D src\cy\atf\utils\utils.py -o src\bin\atf\utils\utils.c
cython -v -D src\cy\atf\utils\list.py -o src\bin\atf\utils\list.c
cython -v -D src\cy\atf\device\ctrl.py -o src\bin\atf\device\ctrl.c
cython -v -D src\cy\atf\traces\wireshark.py -o src\bin\atf\traces\wireshark.c

set GCCARGS=src\bin\libpython27.a
REM set V=-v
set V=
echo Compiling with gcc ...
echo|set /p=Compiler:  
which gcc.exe
echo gcc arguments: %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\base.pyd src\bin\atf\utils\base.c %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\utils.pyd src\bin\atf\utils\utils.c %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\list.pyd src\bin\atf\utils\list.c %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\device\ctrl.pyd src\bin\atf\device\ctrl.c %GCCARGS%
gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\traces\wireshark.pyd src\bin\atf\traces\wireshark.c %GCCARGS%

gcc %V% -shared -O2 -Ic:\Python27\include -o src\bin\atf\utils\dongle.pyd src\cy\atf\utils\dongle.c src\include\libSglW32.a %GCCARGS%
REM compile also into src\cy - otherwise "-P src\cy" executions don't work anymore
gcc %V% -shared -O2 -Ic:\Python27\include -o src\cy\atf\utils\dongle.pyd src\cy\atf\utils\dongle.c src\include\libSglW32.a %GCCARGS%

echo T O O L I N G
echo Compiling with gcc ...
echo|set /p=Compiler: 
which gcc.exe
echo gcc arguments: %GCCARGS%
REM compile dongle manager
gcc %V% -shared -O2 -Ic:\Python27\include -o src\tools\atftools\lic\dadm.pyd src\tools\atftools\lic\dadm.c src\include\libSglW32.a %GCCARGS%

echo C L E A N   U P
del /S src\bin\*.c
del /S src\bin\*.def
del /S src\bin\*.a
del /S src\bin\*.dll

