# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from __future__ import print_function
from robot.parsing import TestData
from robot.running.importer import Importer
from robot.parsing.settings import Library, Resource
import sys

p = '.'
def printLibraries(suite, indent=0):
    global p

    if not suite.children:
        print(" "*indent + suite.name)
        print(" "*indent + "path: " + p)

    # prints also resouces 
    #for x in suite.setting_table.imports:
    #    print("-", x)
    for lib in suite.setting_table.imports:
        importer = Importer()
        if isinstance(lib, Library):
            #print(" "*indent + "- Lib: ", lib.name)
            loaded=importer.import_library(lib.name, None, None, None)
            print(" "*indent + "- Lib: %-20s v%s \t%s scope \t%2d keywords" % (lib.name, loaded.version or '<unknown>', loaded.scope.lower(), len(loaded)))
        if isinstance(lib, Resource):
            print(" "*indent + "- Res: "+ lib.name)
            #res=importer.import_resource(lib.name)
            res=importer.import_resource(p + "\\" + lib.name)
            #attrs = vars(res)
            #for x in attrs:
            #    print(" "*(indent+2) + "-", x)
            for rlib in res.setting_table.imports:
                #print(" "*(indent+4) + "-", rlib)
                if isinstance(rlib, Library):
                    loaded=importer.import_library(rlib.name, None, None, None)
                    print(" "*(indent+2) + "- Res: %-20s v%s \t%s scope \t%2d keywords" % (rlib.name, loaded.version or '<unknown>', loaded.scope.lower(), len(loaded)))

    p = p + "\\" + suite.name.lower().replace(' ','_')

    for child_suite in suite.children:
        p_old = p
        printLibraries(child_suite, indent=indent+2)
        p = p_old



suite = TestData(parent=None, source=sys.argv[1])
printLibraries(suite)