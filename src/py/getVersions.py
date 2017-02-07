# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.
from subprocess import Popen, PIPE

print("ATF Library Versions:")
print("---------------------")
atf_libs = [('ATFCommons', 'ATFCommons'), ('BrowserControl', 'BrowserControl'), ('DeviceControl', 'DeviceControl'), ('Wireshark', 'Wireshark'), ('my.module.path', 'myClass')]
for a_lib in atf_libs:
    try:
        mod = __import__(a_lib[0], fromlist=[a_lib[1]])
        a_class = getattr(mod, a_lib[1])
        print("%-20s  v%-10s \033[0;37m(%s)\033[0m" % (a_lib[1], a_class.ROBOT_LIBRARY_VERSION,  a_class.ROBOT_LIBRARY_BUILD))
    except Exception as ex:
        #print("%s" % str(ex))
        pass

print("\nRF Library Versions:")
print("--------------------")
rf_libs = [('robot.libraries.BuiltIn', 'BuiltIn'), ('SSHLibrary', 'SSHLibrary'), ('AppiumLibrary', 'AppiumLibrary'), ('robot.libraries.XML', 'XML'), ('Selenium2Library', 'Selenium2Library'), ('my.module.path', 'myClass')]
for a_lib in rf_libs:
    try:
        mod = __import__(a_lib[0], fromlist=[a_lib[1]])
        a_class = getattr(mod, a_lib[1])
        pip_list = {
            "SSHLibrary":"paramiko",
            "AppiumLibrary":"appium-python-client",
            "Selenium2Library": "selenium ",
            "XML": "lxml ",
        }
        p_pip = Popen(["pip", "list"], stdout=PIPE)
        p_grep = Popen(["egrep", pip_list.get(a_lib[1], "ThisLibIsNotExisting")], stdin=p_pip.stdout, stdout=PIPE)
        p_pip.stdout.close()
        (output, err) = p_grep.communicate()
        exit_code = p_grep.wait()
        if exit_code == 0:
            pip_txt = "\033[0;37m[%s]\033[0m" % output.replace("\n","")
        else:
            pip_txt = ""
        print("%-20s  v%-10s %s" % (a_lib[1], a_class.ROBOT_LIBRARY_VERSION, pip_txt))
    except:
        pass

