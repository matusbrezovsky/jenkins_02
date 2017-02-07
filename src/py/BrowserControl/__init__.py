# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atfwrappers.browsers import BrowserCtrlWrapper
from atf.utils.list import AtfListener

class BrowserControl(AtfListener, BrowserCtrlWrapper):
    """
    BrowserControl Library for steering Devices
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '2.1-dev'
    ROBOT_LIBRARY_BUILD = '' + '1124Wed_96b08d0_201610141226'

    def __init__(self):
        for base in BrowserControl.__bases__:
            base.__init__(self)
        #CommonsImpl.__init__(self)

