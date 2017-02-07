*** Settings ***
Library     Process
Library     Collections
Library     StartAp.py
Resource    global_vars.txt

*** Settings ***
Suite Setup  create device aliases

*** Test Cases ***

#stop forgotten server
#    stop appium   Demo1   port=4712     # stops forgotten one

start appium servers
    run appium    Demo1   port=4710     address=127.0.0.1   optional_args=--command-timeout 2500 --device-ready-timeout 180 --log-level debug
    run appium    Demo2   port=4701
    run appium    Demo3   optional_args=--command-timeout 2500 --device-ready-timeout 180 --log-level debug
    # run appium    whatever   port=4712     address=127.0.0.1
    appium should be running    Demo3
    appium should be running    Demo2

stop appium servers
    stop appium   Demo2
    stop appium   Demo3
    stop appium   Demo1

should not run test
    appium should not be running    Demo1
    appium should not be running    Demo2
    
should run test
    run appium    Demo2
    appium should be running    Demo2
    
stop appium server
    stop appium    Demo2
    
check if everything stopped
    appium should not be running    Demo1
    appium should not be running    Demo2
    appium should not be running    Demo3
    appium should not be running    Demo4
    
#forgotten appium test
#    run appium  Demo1   port= 4712
   

    