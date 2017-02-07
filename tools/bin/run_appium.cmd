REM SET LOG_LEVEL=--log-level debug
SET LOG_LEVEL=--log-level warn:warn
start "Appium:4700" /MIN /D %APPIUM_HOME% cmd /K appium.cmd 4700 4800 %APPIUM_ROOT%\appium4723.log %LOG_LEVEL%
start "Appium:4701" /MIN /D %APPIUM_HOME% cmd /K appium.cmd 4701 4801 %APPIUM_ROOT%\appium4724.log %LOG_LEVEL%
start "Appium:4702" /MIN /D %APPIUM_HOME% cmd /K appium.cmd 4702 4802 %APPIUM_ROOT%\appium4726.log %LOG_LEVEL%
start "Appium:4703" /MIN /D %APPIUM_HOME% cmd /K appium.cmd 4703 4803 %APPIUM_ROOT%\appium4727.log %LOG_LEVEL%
REM start "Appium:4728" /MIN /D %APPIUM_HOME% cmd /K appium.cmd 4728 4828 %APPIUM_ROOT%\appium4728.log %LOG_LEVEL%
