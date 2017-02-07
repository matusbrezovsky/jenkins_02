@echo off
IF "%1" == "install" (
	echo START INSTALL > atf_usb_drv.log
	echo ANDROID USB DRIVERS
	echo Currently supports only 64bit Windows Drivers
	echo|set /p=Installing Android USB Drivers for Huawei Devices . 
	pnputil -a .\drivers\android_winusb.inf_amd64_a60edd9293116ae0\*.inf    >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_goadb.inf_amd64_28c49a286d234606\*.inf          >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_gohdb.inf_amd64_6d8428de3fadff2f\*.inf          >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_qumdm.inf_amd64_e2d7837a481e11fb\*.inf          >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_quser.inf_amd64_9933bce989d47840\*.inf          >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_quusbnet.inf_amd64_6556c2bfaa193697\*.inf       >> atf_usb_drv.log & echo|set /p=.
	pnputil -a .\drivers\hw_usbdev.inf_amd64_61f3379efae54146\*.inf         >> atf_usb_drv.log & echo|set /p=.
	echo done
	echo STOP INSTALL > atf_usb_drv.log
)
IF "%1" == "uninstall" (
	echo !!! Automatic USB Driver Uninstall not supported !!!
	echo Open Device Manager and uninstall from there
	echo NOTE: this probably still leaves the drivers in the Driver Store 
)

