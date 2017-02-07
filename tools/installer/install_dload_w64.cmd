@echo off

SETLOCAL

Call i_setenv.cmd
echo D O W N L O A D I N G   I N S T A L L A T I O N   F I L E S
echo (NOTE: does not work if you are behind a proxy, see README.txt for more details)
echo START DLOAD > atf_dload.log

CALL :download_from_dropbox  w64  runtime     "https://www.dropbox.com/s/rf1z3q38ii2j4o7/atf_installer_v1.0_w64_runtime.zip?dl=0"
CALL :download_from_dropbox  w64  tools       "https://www.dropbox.com/s/yig8ru8iuubv4hp/atf_installer_v1.0_w64_tools.zip?dl=0"
CALL :download_from_dropbox  w64  planB       "https://www.dropbox.com/s/h4df2yifizl6qs0/atf_installer_v1.0_common_planB.zip?dl=0"
echo STOP DLOAD >> atf_dload.log
GOTO :eof


:download_from_dropbox
echo Downloading %1 %2 from %3
SET ZIP_NAME=atf_installer_%1_%2.zip
curl -kL# -o %ZIP_NAME% %3
echo|set /p=Unzipping %ZIP_NAME% .
7z x -y -o. %ZIP_NAME%                  >> atf_dload.log 2>&1 & echo|set /p=.
echo done
GOTO :eof
