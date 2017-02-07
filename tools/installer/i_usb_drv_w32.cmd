@echo off
IF "%1" == "install" (
	echo START INSTALL > atf_usb_drv.log
	echo ANDROID USB DRIVERS
	echo Currently not supported!!!
	echo done
	echo STOP INSTALL > atf_usb_drv.log
)
IF "%1" == "uninstall" (
	echo !!! Automatic USB Driver Uninstall not supported !!!
	echo Open Device Manager and uninstall from there
	echo NOTE: this probably still leaves the drivers in the Driver Store 
)

