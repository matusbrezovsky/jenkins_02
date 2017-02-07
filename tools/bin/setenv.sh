#!/usr/bin/env bash
# run this before starting appium, git etc.
# or add these to the user's .bash_profile
ANDROID_HOME=/usr/local/Cellar/android-sdk/24.3.3/
TA_HOME=~/demos/ta/
PATH=${PATH}:${ANDROID_HOME}:${TA_HOME}/tools/bin:$HOME/.node/bin

export ANDROID_HOME
export TA_HOME
export PATH
