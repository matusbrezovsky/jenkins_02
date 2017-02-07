@echo off
SETLOCAL
rem TODO: add proxy support
rem TODO: add HW USB driver (HiSuite)
rem TODO: add Smasung USB driver
rem TODO: add cygwin & sshd
Call i_setenv.cmd
echo I N S T A L L I N G   T O O L I N G
call i_git_w64.cmd        install
call i_pyCharm.cmd        install
call i_npp_w64.cmd        install

