@echo off
rem TODO: add cygwin & sshd
Call i_setenv.cmd
echo U N I N S T A L L I N G   T O O L I N G
call i_git_w64.cmd        uninstall
call i_pycharm_w64.cmd    uninstall
call i_npp_w64.cmd        uninstall

echo U N I N S T A L L I N G   R U N T I M E
call i_wireshark_w64.cmd  uninstall
call i_droid.cmd      	  uninstall
call i_appium.cmd     	  uninstall
call i_pip.cmd        	  uninstall
call i_atf_addons.cmd     uninstall
call i_java_w64.cmd       uninstall
call i_python.cmd         uninstall
call i_usb_drv_w64.cmd    uninstall

echo done!
    