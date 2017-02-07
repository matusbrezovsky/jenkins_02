@echo off
rem TODO: add proxy support
rem TODO: add minGW to tools
rem TODO: add HW USB driver (HiSuite)
rem TODO: add Smasung USB driver
rem TODO: add cygwin & sshd
Call i_setenv.cmd
Call install_dload_w32.cmd
Call install_tools_w32.cmd
Call install_runtime_w32.cmd

echo INSTALLED VERSIONS
python --version
java -version
tshark -v
git --version
adb version
pybot --version
echo done!

rem msiexec /Option <Required Parameter> [Optional Parameter]
rem 
rem Install Options
rem 	</package | /i> <Product.msi>
rem 		Installs or configures a product
rem 	/a <Product.msi>
rem 		Administrative install - Installs a product on the network
rem 	/j<u|m> <Product.msi> [/t <Transform List>] [/g <Language ID>]
rem 		Advertises a product - m to all users, u to current user
rem 	</uninstall | /x> <Product.msi | ProductCode>
rem 		Uninstalls the product
rem Display Options
rem 	/quiet
rem 		Quiet mode, no user interaction
rem 	/passive
rem 		Unattended mode - progress bar only
rem 	/q[n|b|r|f]
rem 		Sets user interface level
rem 		n - No UI
rem 		b - Basic UI
rem 		r - Reduced UI
rem 		f - Full UI (default)
rem 	/help
rem 		Help information
rem Restart Options
rem 	/norestart
rem 		Do not restart after the installation is complete
rem 	/promptrestart
rem 		Prompts the user for restart if necessary
rem 	/forcerestart
rem 		Always restart the computer after installation
rem Logging Options
rem 	/l[i|w|e|a|r|u|c|m|o|p|v|x|+|!|*] <LogFile>
rem 		i - Status messages
rem 		w - Nonfatal warnings
rem 		e - All error messages
rem 		a - Start-up of actions
rem 		r - Action-specific records
rem 		u - User requests
rem 		c - Initial UI parameters
rem 		m - Out-of-memory or fatal exit information
rem 		o - Out-of-disk-space messages
rem 		p - Terminal properties
rem 		v - Verbose output
rem 		x - Extra debugging information
rem 		+ - Append to existing log file
rem 		! - Flush each line to the log
rem 		* - Log all information, except for v and x options
rem 	/log <LogFile>
rem 		Equivalent of /l* <LogFile>
rem Update Options
rem 	/update <Update1.msp>[;Update2.msp]
rem 		Applies update(s)
rem 		
rem 