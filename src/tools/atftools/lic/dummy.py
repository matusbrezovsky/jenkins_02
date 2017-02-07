from robot.libraries.BuiltIn import BuiltIn
from robot.output import LOGGER

import time

class Dummy(object):

    def __init__(self):
        self._bi = BuiltIn()

    def crash(self):
        exit(11)
