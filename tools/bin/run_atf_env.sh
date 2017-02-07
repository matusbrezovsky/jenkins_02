#!/usr/bin/env bash
#
# START APPIUM
#
source ~/.bash_profile

osascript \
-e 'tell application "Terminal"' \
-e '    do script "modterm.sh Appium-4723 20 180 0 0 33 41 2; appium --port 4723 --bootstrap-port  4823 --command-timeout 900 --device-ready-timeout 120 --platform-name Android --platform-version 19 --automation-name Appium --log-timestamp --local-timezone --session-override " ' \
-e 'end tell'

osascript \
-e 'tell application "Terminal"' \
-e '    do script "modterm.sh Appium-4724 20 180 0 310 33 41 2; appium --port 4724 --bootstrap-port  4824 --command-timeout 900 --device-ready-timeout 120 --platform-name Android --platform-version 19 --automation-name Appium --log-timestamp --local-timezone --session-override" ' \
-e 'end tell'

#
# Open console and tail debug log
#
osascript \
-e 'tell application "Terminal"' \
-e "    do script \"modterm.sh TA-log 60 180 0 0 30 47 2; cd $TA_HOME; tail -F debug.log | egrep ' - dbg: | START TEST|END TEST|START SUITE|END SUITE|TEARDOWN|SETUP'\" " \
-e 'end tell'

#
# Open robot console
#
osascript \
-e 'tell application "Terminal"' \
-e '    do script "modterm.sh TA-console 35 80 700 0 30 49 2; cd '$TA_HOME'; python -m robot.run --version" ' \
-e 'end tell'

