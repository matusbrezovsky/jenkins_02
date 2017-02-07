# Copyright (c) 2014-2016 Jari Nurminen
# All Rights Reserved
# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential
# Author: Jari Nurminen <jari.nurminen@iki.fi>
# 
# Dissemination of this information or reproduction of this material
# via any medium is strictly forbidden unless prior written permission 
# is obtained from Jari Nurminen.

from atf.web.po import BasePageObject
#from atf.web.ctrl import BrowserControl
import atf
#from .browser_configs_default import settings_gmail
import time
from selenium import webdriver
from selenium.webdriver.remote.webelement import WebElement
import robot


class GmailPageObject(BasePageObject):
    _app_cfg = None
    """:type _app_cfg: browser_configs_default.settings_gmail_en_gb """    # docstring for pycharm code-completion
    _brw_cfg = None
    """:type _brw_cfg: browser_configs_default.WEB_APPS """    # docstring for pycharm code-completion

    # __init__ override is required, otherwise the execution fails with
    # "TypeError: <cyfunction BasePageObject.__init__ at 0x037209F0> is not a Python function"
    def __init__(self):
        for base in GmailPageObject.__bases__:
            base.__init__(self)

class LoginPage(GmailPageObject):

    PAGE_TITLE = "Gmail"
    PAGE_URL = "/"

    @property
    def PAGE_LOCATOR(self):
        return GmailPageObject._app_cfg.login_btn_next

    # https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#identifier
    def login(self, alias, user):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.LoginPage")

        # without navigate()
        #self._se2.input_text(GmailPageObject._app_cfg.login_txt_user, user)
        #with self._wait_for_page_refresh(stale_check=False):
        #    self._se2.click_element(GmailPageObject._app_cfg.login_btn_next)
        # with navigate()
        # sometimes too fast = "next" is not yet active when clicking it
        with self._wait_for_page_refresh(stale_check=False):
            self._br._navigate(alias, GmailPageObject._app_cfg.login_sequence, username=user)

class PasswdPage(GmailPageObject):

    PAGE_TITLE = "Gmail"
    PAGE_URL = "/"

    @property
    def PAGE_LOCATOR(self):
        return GmailPageObject._app_cfg.login_btn_login

    # https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=https://mail.google.com/mail/&ss=1&scc=1&ltmpl=default&ltmplcache=2&emr=1&osid=1#identifier
    def passwd(self, alias, pwd, remember=False):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.PasswdPage")

        with self._wait_for_page_refresh(stale_check=False):
            time.sleep(3)
        self._se2.input_text(GmailPageObject._app_cfg.login_txt_pwd, pwd)
        self._se2.unselect_checkbox(GmailPageObject._app_cfg.login_cbx_keep)
        self._se2.click_element(GmailPageObject._app_cfg.login_btn_login)

class GmailConstantFrame(GmailPageObject):

    def logout(self, alias):
        self._se2.switch_browser(alias)

        with self._wait_for_page_refresh():
            self._se2.click_element(GmailPageObject._app_cfg.usr_banner_logout_link)

    def go_to_inbox(self, alias):
        self._se2.switch_browser(alias)

        with self._wait_for_page_refresh():
            self._se2.click_element("xpath = //a[contains(text(),'Inbox')]")
        self._br.current_page_should_be(alias, "gmail.InboxPage")

class InboxPage(GmailConstantFrame):
    PAGE_TITLE = "Gmail - Inbox"
    PAGE_URL = "/mail/" # https://mail.google.com/mail/u/0/h/f6fk5xwj81s2/?zy=g&f=1

    @property
    def PAGE_LOCATOR(self):
        return GmailPageObject._app_cfg.inbox_lnk_refresh

    def delete_emails_containing(self, alias, email_string):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.InboxPage")

        del_locator = "xpath = //table[@class='th']//tr[.//*[contains(.,'%s')]]//input" % email_string
        del_chkboxes = self._se2.get_webelements(del_locator)
        #del_chkboxes = self._se2._current_browser().find_elements_by_xpath("//table[@class='th']//tr[.//*[contains(.,'oobie')]]//input")
        for chkbox in del_chkboxes:
            chkbox.click()
        with self._wait_for_page_refresh():
            self._se2.click_element(GmailPageObject._app_cfg.inbox_btn_del_name)

    def open_email_thread_containing(self, alias, email_string, index=1):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.InboxPage")

        eml_locator = "xpath = //table[@class='th']//tr[.//*[contains(.,'%s')]][%s]//a" % (email_string, index)
        with self._wait_for_page_refresh():
            self._se2.click_element(eml_locator)

        if self._se2._is_visible(GmailPageObject._app_cfg.read_email_lnk_expand_all):
            with self._wait_for_page_refresh(stale_check=False):
                self._se2.click_element(GmailPageObject._app_cfg.read_email_lnk_expand_all)

    #def _wait_and_refresh_until_no_error(self, timeout, wait_func, *args):
    #    timeout = robot.utils.timestr_to_secs(timeout) if timeout is not None else 10
    #    maxtime = time.time() + timeout
    #    while True:
    #        timeout_error = wait_func(*args)
    #        if not timeout_error: return
    #        if time.time() > maxtime:
    #            raise AssertionError(timeout_error)
    #        time.sleep(5)
    #        with self._wait_for_page_refresh():
    #            self._se2.click_element(GmailPageObject._app_cfg.inbox_lnk_refresh)

    def wait_for_email_containing(self, alias, email_string, timeout='30s'):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.InboxPage")
        eml_locator = "xpath = //table[@class='th']//tr[.//*[contains(.,'%s')]]" % email_string

        def check_visibility():
            visible = self._se2._is_visible(eml_locator)
            if visible:
                return
            else:
                #return "Email containing '%s' was not visible in %s" % (email_string, timeout)
                raise Exception("Email containing '%s' was not visible" % (email_string))

        #self._wait_and_refresh_until_no_error(timeout, check_visibility)
        my_assert = (check_visibility, None, None)
        my_err = (self._br.run_on_browser_error, None, None)
        timeout = robot.utils.timestr_to_secs(timeout) if timeout is not None else 10
        self._atfc._wait_until_no_error(30, timeout, my_assert, error_func=my_err, msg="Did not receive Email containing '%s' within %s seconds" % (email_string, timeout))

    def open_compose_email(self, alias):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.InboxPage")
        eml_locator = "xpath = //a[@accesskey='c' and contains(text(), 'Compose')]"
        with self._wait_for_page_refresh():
            self._se2.click_element(eml_locator)

class ReadEmailPage(GmailConstantFrame):
    PAGE_TITLE = "Gmail - Inbox"
    PAGE_URL = "/mail/" # https://mail.google.com/mail/u/0/h/f6fk5xwj81s2/?zy=g&f=1

    @property
    def PAGE_LOCATOR(self):
        return "xpath = //a[@class='searchPageLink' and contains(text(),'Back to Inbox')]"

    def go_back_to_inbox(self, alias):
        self._se2.switch_browser(alias)
        # select the main window, just in case we have opened an attachment into another window 
        self._se2.select_window()
        self._br.current_page_should_be(alias, "gmail.ReadEmailPage")

        with self._wait_for_page_refresh():
            self._se2.click_element(GmailPageObject._app_cfg.read_email_lnk_to_inbox)

    def get_email(self, alias, email_string, index=None):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ReadEmailPage")
        if index is None:
            eml_locator = "xpath = //table//table//table[.//*[contains(.,'%s')] and .//table][last()]" % (email_string)
        else:
            eml_locator = "xpath = //table//table//table[.//*[contains(.,'%s')] and .//table][last()-%s]" % (email_string, index)
        return self._se2.get_webelement(eml_locator)

    def get_email_text(self, alias, email_string, index=None):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ReadEmailPage")

        #if index is None:
        #    eml_locator = "xpath = //table//table//table[.//*[contains(.,'%s')] and .//table][last()]//div[@class='msg']" % (email_string)
        #else:
        #    eml_locator = "xpath = //table//table//table[.//*[contains(.,'%s')] and .//table][last()-%s]//div[@class='msg']" % (email_string, index)
        #eml_txt_blocks = self._se2.get_webelements(eml_locator)
        eml_ele = self.get_email(alias, email_string, index=index)
        eml_txt_blocks = eml_ele.find_elements_by_xpath("//div[@class='msg']")

        eml_txt = u''
        for eml_txt_block in eml_txt_blocks:
            eml_txt = eml_txt + eml_txt_block.text
        return eml_txt

    def view_pdf_as_html(self, alias, email_string, pdf_file, index=None):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ReadEmailPage")

        eml_ele = self.get_email(alias, email_string, index=index)
        link_to_pdf = eml_ele.find_element_by_xpath("//a[contains(text(), 'View as HTML')]")
        with self._wait_for_page_refresh(stale_check=False):
            link_to_pdf.click()
        self._se2.select_window("title = %s" % pdf_file)

    def get_pdf_txt(self, alias):
        self._se2.switch_browser(alias)
        #self._br.current_page_should_be(alias, "gmail.ReadEmailPage")

        pdf_locator = "xpath = //body/div"
        pdf_txt_blocks = self._se2.get_webelements(pdf_locator)
        pdf_txt = u''
        for pdf_txt_block in pdf_txt_blocks:
            pdf_txt = pdf_txt + pdf_txt_block.text
        return pdf_txt

    def close_pdf(self, alias):
        self._se2.switch_browser(alias)
        #self._br.current_page_should_be(alias, "gmail.ReadEmailPage")

        self._se2.close_window()
        self._se2.select_window()


class ComposeEmailPage(GmailConstantFrame):
    PAGE_TITLE = "Gmail - Compose Mail"
    PAGE_URL = "/mail/" # https://mail.google.com/mail/h/7u07e1oyj68c/?&

    @property
    def PAGE_LOCATOR(self):
        return "xpath = /html/body/table[2]/tbody/tr/td[2]/table[1]/tbody/tr/td[2]/form/table[1]/tbody/tr/td/input[2]"
        #return "xpath = //a[contains(text(), 'Attachment')]"

    def compose_email(self, alias, to_string, subject, email_string):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ComposeEmailPage")

        with self._wait_for_page_refresh(stale_check=False):
            self._br._navigate(alias, GmailPageObject._app_cfg.compose_email_sequence, receiver=to_string, subject=subject, text=email_string)




    def attach_file(self, alias, file):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ComposeEmailPage")

        fileinput =  self._se2.get_webelement('file0')
        fileinput.send_keys(file)




    def send_email(self, alias):
        self._se2.switch_browser(alias)
        self._br.current_page_should_be(alias, "gmail.ComposeEmailPage")

        with self._wait_for_page_refresh(stale_check=False):
            self._br._navigate(alias, GmailPageObject._app_cfg.send_email_sequence)
#            self._se2.click_element(GmailPageObject._app_cfg.send_email_btn)

    def discard_email(self, alias):
        self._se2.switch_browser(alias)
        # select the main window, just in case we have opened an attachment into another window
        self._se2.select_window()
        self._br.current_page_should_be(alias, "gmail.ComposeEmailPage")

        self._br._navigate(alias, GmailPageObject._app_cfg.discard_email_sequence)
        self._se2.dismiss_alert()
