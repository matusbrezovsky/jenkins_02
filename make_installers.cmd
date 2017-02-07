@echo off

SETLOCAL
SET INST_VER=v1.0

SET HOME_DIR=c:\git\ta\
SET INST_DIR=c:\git\ta\tools\installer\
SET BIN_DIR=C:\git\ta-installer\
SET TARGET_DIR=C:\JNU\segron_dropbox\Dropbox\
SET PACKAGE_NAME=atf_installer
SET LOG_FILE=%HOME_DIR%make_installer.log


CALL :make_scripts_package     w32
CALL :make_scripts_package     w64
IF "%1" == "all" (
  CALL :make_installer_package w32     runtime
  CALL :make_installer_package w64     runtime
  CALL :make_installer_package w32     tools
  CALL :make_installer_package w64     tools
  CALL :make_installer_package common  planB
)

cd %HOME_DIR%
GOTO :eof

:make_installer_package
SET PCKG=%2
SET X=%1
SET ZIP_NAME=%PACKAGE_NAME%_%INST_VER%_%X%_%PCKG%.zip
echo|set /p=Creating %TARGET_DIR%%ZIP_NAME%
rm -f %TARGET_DIR%%ZIP_NAME%                                                                                               & echo|set /p=.
cd %BIN_DIR%\%PCKG%                                                                                                        & echo|set /p=.
IF "%1" == "common" (
  7z a -y -bd -bso1 -bse1 %TARGET_DIR%%ZIP_NAME% @%INST_DIR%%PCKG%_common.files                              >> %LOG_FILE% & echo|set /p=.
) ELSE (
  7z a -y -bd -bso1 -bse1 %TARGET_DIR%%ZIP_NAME% @%INST_DIR%%PCKG%_%X%.files @%INST_DIR%%PCKG%_common.files  >> %LOG_FILE% & echo|set /p=.
)
echo  done
GOTO :eof

:make_scripts_package
SET X=%1
SET ZIP_NAME=%PACKAGE_NAME%_%INST_VER%_%X%_scripts.zip
echo|set /p=Creating %TARGET_DIR%%ZIP_NAME%
rm -f %TARGET_DIR%%ZIP_NAME%                                                                                               & echo|set /p=.
cd %INST_DIR%                                                                                                              & echo|set /p=.
7z a -y -bd -bso1 -bse1 %TARGET_DIR%%ZIP_NAME% @installer_%X%.files @installer_common.files                  >> %LOG_FILE% & echo|set /p=.
cd ..                                                                                                                      & echo|set /p=.
7z a -y -bd -bso1 -bse1 %TARGET_DIR%%ZIP_NAME% bin                                                           >> %LOG_FILE% & echo|set /p=.
echo  done
GOTO :eof

