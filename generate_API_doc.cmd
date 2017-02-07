@echo off
SETLOCAL

set WRP_FILE=src\py\atfwrappers\commons.py
set LIB_NAME=ATFCommons
set WRP_NAME=UtilsWrapper
REM comment code
set CLS_FILE=src\py\%LIB_NAME%\__init__.py
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/.*/#&/" %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(AtfListener, %WRP_NAME%)/(%WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%
REM generate
python -m robot.libdoc -P src\bin -P src\py %LIB_NAME% doc\%LIB_NAME%.html
REM uncomment code
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/^#//"  %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(%WRP_NAME%)/(AtfListener, %WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%


set WRP_FILE=src\py\atfwrappers\devices.py
set LIB_NAME=DeviceControl
set WRP_NAME=DeviceCtrlWrapper
REM comment code
set CLS_FILE=src\py\%LIB_NAME%\__init__.py
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/.*/#&/" %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(AtfListener, %WRP_NAME%)/(%WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%
REM generate
python -m robot.libdoc -P src\bin -P src\py %LIB_NAME% doc\%LIB_NAME%.html
REM uncomment code
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/^#//"  %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(%WRP_NAME%)/(AtfListener, %WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%


set WRP_FILE=src\py\atfwrappers\traces.py
set LIB_NAME=Wireshark
set WRP_NAME=WsWrapper
REM comment code
set CLS_FILE=src\py\%LIB_NAME%\__init__.py
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/.*/#&/" %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(AtfListener, %WRP_NAME%)/(%WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%
REM generate
python -m robot.libdoc -P src\bin -P src\py %LIB_NAME% doc\%LIB_NAME%.html
REM uncomment code
sed "/CUDO_BLOCK_START/,/CUDO_BLOCK_END/s/^#//"  %WRP_FILE% > %WRP_FILE%.sed
mv -f %WRP_FILE%.sed %WRP_FILE%
sed "/class %LIB_NAME%/,/class %LIB_NAME%/s/(%WRP_NAME%)/(AtfListener, %WRP_NAME%)/"  %CLS_FILE% > %CLS_FILE%.sed
mv -f %CLS_FILE%.sed %CLS_FILE%
