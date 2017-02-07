# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atf.web.ctrl import BrowserControl
import browser_configs_default
from robot.output import LOGGER


class BrowserCtrlWrapper():
    # class BrowserCtrlWrapper(BrowserControl):

    def __init__(self):
        # comment this block for API doc generation:
        # CUDO_BLOCK_START
        LOGGER.info('ATF initiate: BrowserControl binary library')
        self._w = BrowserControl()
        LOGGER.info('ATF initiate: OK')
        # CUDO_BLOCK_END
        pass

    #############################################################################################
    def browser_setup(self):
        """
        Initiate resources for browser management

        Prepares framework resources for the browser management. Does not trigger any activity on the
        browsers.

        To be used in Test Suite or Test Case Setup
        """
        self._w.browser_setup()

    def browser_cleanup(self):
        self._w.browser_cleanup()

    def initiate_browser(self, alias, browser, app_to_launch):
        self._w.initiate_browser(alias, browser, app_to_launch)

    def release_browser(self, alias):
        self._w.release_browser(alias)

    def current_page_should_be(self, alias, page_name):
        self._w.current_page_should_be(alias, page_name)

    def go_to_page(self, alias, page_name, page_root=None):
        self._w.go_to_page(alias, page_name, page_root=page_root)

    def run_on_browser_error(self):
        self._w.run_on_browser_error()

    ##############################################################################################
    #   PRIVATE
    ##############################################################################################
    def _navigate(self, ui_alias, nav_map, fail_on_error=True, **kwargs):
        return self._w._navigate(ui_alias, nav_map, fail_on_error=fail_on_error, **kwargs)

    @property
    def _sao(self):
        """
        :rtype: atf.web.selenium.AddOn
        """
        return self._w._s2_addon