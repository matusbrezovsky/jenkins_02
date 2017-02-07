from atftools.lic.dadm import *
from atf.utils.list import AtfListener

from robot.libraries.BuiltIn import BuiltIn
from robot.output import LOGGER

import atf.utils.list
import time

class LicMgr(object):

    def __init__(self):
        self._bi = BuiltIn()

    def auth_dongle(self, prod_id):
        auth_sgl(int(prod_id))

    def get_counter(self, prod_id, cnt_id):
        (ret, val) = cnt_get(int(prod_id), int(cnt_id))
        if ret != atf.utils.list.SGL_SUCCESS:
            self._bi.fail("SGL ERROR %s" % ret)
        return val

    def set_counter(self, prod_id, cnt_id, cnt):
        ret = cnt_set(int(prod_id), int(cnt_id), int(cnt))
        if ret != atf.utils.list.SGL_SUCCESS:
            self._bi.fail("SGL ERROR %s" % ret)

    def get_data(self, prod_id, data_id):
        (ret, val) = data_get_uint(int(prod_id), int(data_id))
        if ret != atf.utils.list.SGL_SUCCESS:
            self._bi.fail("SGL ERROR %s" % ret)
        return val

    def set_data(self, prod_id, data_id, data):
        ret = data_set_uint(int(prod_id), int(data_id), int(data))
        if ret != atf.utils.list.SGL_SUCCESS:
            self._bi.fail("SGL ERROR %s" % ret)
