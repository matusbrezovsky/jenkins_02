@echo off
SETLOCAL
Call i_setenv.cmd
echo I N S T A L L I N G   R U N T I M E
echo (NOTE: does not work if you are behind a proxy, see README.txt for more details)
call i_java_w32.cmd       install
call i_python.cmd         install
call i_pip.cmd            install
call i_atf_addons.cmd     install
call i_droid.cmd          install
call i_usb_drv_w32.cmd    install
call i_wireshark_w32.cmd  install
call i_appium.cmd         install
