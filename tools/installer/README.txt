A T F   I N S T A L L A T I O N   S C R I P T S

Version:    1.0.3
Authot:     Jari Nurminen

Version History:
----------------
v1.0.3 (05.04.2016)
    - segron report templates v2.9.2
    - pip 8.0.2 --> 8.1.1
    - PyCharm 4.5.4 --> 5.0.4
    - appium 1.4.13.1 --> 1.4.16.1
v1.0.2 (17.02.2016)
    - segron report templates v2.8.7 update (table colors)
v1.0.1 (13.02.2016)
    - robot framework 2.8.7 --> 2.9.2
    - AppiumLibrarry 1.3.5 (pip) --> 1.3.5-2 (github)
    - segron report templates v2.8.7
v1.0.0
    - first version

Installation:
-------------
Download the installation scripts:
win32: https://www.dropbox.com/s/vi1tcix5yjv0an7/atf_installer_v1.0_w32_scripts.zip?dl=0
win64: https://www.dropbox.com/s/n9ce5dxyce9yj40/atf_installer_v1.0_w64_scripts.zip?dl=0

1) Unpack the scripts into a directory (e.g. c:\atfinstaller)
2) Open windows command prompt as Administrator (e.g. <windows key> / type "cmd" / right-click cmd / "run as administrator")

In the command Prompt window:
    3) cd into that installer directory (e.g. cd c:\atfinstaller)
    4) run install_w32.cmd or install_w64.cmd, depending on your windows architecture
    5) wait patiently for the installation to finish
    6) If everything was successful you can now get the git repository
    6.1) run "mkdir \git"
    6.2) run "cd \git"
    6.3) run "git clone <your git repo>" (e.g. "git clone https://github.com/yahman72/taTest")

7) Open file explorer and goto <your git repo directory>\tools\bin (e.g. "c:\git\taTest\tools\bin")
8) double-click on "runrobotenv.cmd" --> this should open all necessary windows


Behind a proxy?
before step 4)
run the following in the command prompt:
"set http_proxy=http://<yourproxy host>:<yourproxy port>/"
"set https_proxy=https://<yourproxy host>:<yourproxy port>/"
--> proceed with step 4)

The installation will fail, because adb is not working (Android Debug Bridge)
--> run "android" in the command prompt
--> this will open the Android SDK Manager
--> in the SDK Manager: select
    "Tools" / "Options..." / enter your proxy settings and accept changes + close SDK Manager
    (this will save the proxy settings)
--> run "i_droid.cmd install" in the command prompt
--> verify installation i.e. run these in the command prompt:
    python --version
    java -version
    tshark -v
    git --version
    adb version
    pybot --version
    --> None of the commands should produce an error

-----------------------------------------------------------------------------------------

TODO/Known Issues:
- Add Proxy support
- Include Win32 - USB Drivers for Y550
- Include Win32 & Win64 - USB Drivers for S5
- Include development tooling (cython, MinGW, Cygwin + sshd)
- Upgrade PyCharm to 5.0 + latest plugins + latest settings
- Update rebot templates to the latest ones



