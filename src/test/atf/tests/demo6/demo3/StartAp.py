from subprocess import Popen
from subprocess import CalledProcessError
from os import kill
from os import environ
import time, urllib2
import httplib
from psutil import net_connections
from psutil import AccessDenied
from signal import SIGTERM
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
import SocketServer


class StartAp():

    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __int__(self):
        # self._bi = BuiltIn()   # does not work here, in suite setup create_device_aliases is called, it works from there
        pass

    def create_device_aliases(self):
        """
        keyword must be called in suite_setup
        creates dictionary dev_alias: dev_id
        """
        self._bi = BuiltIn()
        alias_list = self._bi.get_variable_value("@{ALIAS_LIST}")
        dev_list = self._bi.get_variable_value("@{DEV_LIST}")
        dev_aliases = dict(zip(alias_list, dev_list))
        running_al = set()  # list of running aliases to ensure uniqness of aliases, run Demo1 4710, run Demo1 4701 problem solved
        self._bi.set_global_variable("${device_aliases}", dev_aliases)
        self._bi.set_global_variable("${running_aliases}", running_al)

    def get_device_args(self, alias):
        """
        getter for dictionary device_aliases
        - alias     device alias

        Returns host(ip address), port
        """
        devices = self._bi.get_variable_value("${device_aliases}")

        try:
            dev = devices[alias]
        except KeyError:
            return self._bi.fail("Could not get appium server with given alias, device " + alias + " does not exists in global_vars.txt")

        port = self._bi.get_variable_value(str("${" + dev + "_PORT}"))
        host = self._bi.get_variable_value(str("${" + dev + "_HOST}"))
        return (host, port)


    def run_appium(self, alias, host=None, port=None, **kwargs):
        """
        starts appium server with given arguments,
        example : run appium | Demo1 | host=127.0.0.1 | port=4705 | optional_args= --command-timeout 2800 --log-level debug
        example : run appium | Demo2 | port=4703
        all of arguments are optional
        - alias     device alias
        - host      ip address
        - port      device port

        Returns Pass if appium started, fails otherwise
        """
        running_al = self._bi.get_variable_value("${running_aliases}")
        if alias in running_al:
            return self._bi.fail("Could not start appium server " + alias + ", appium already running with same alias, aliases must be uniqe")
        devices = self._bi.get_variable_value("${device_aliases}")
        if host is None:  # set host and port
            host = self.get_device_args(alias)[0]
        else:
            self._bi.set_global_variable("${" + devices[alias] + "_HOST}", host)
            logger.info("starting appium on ip " + host)
        if port is None:
            port = self.get_device_args(alias)[1]
        else:
            self._bi.set_global_variable("${" + devices[alias] + "_PORT}", port)
            logger.info("starting appium on non-standard port " + port)
        if self.is_running(host, port):
            return self._bi.fail("Could not start appium server" + alias + " at port " + port + ", port is already running")

        optional_args = kwargs.get('optional_args', '')
        try:
            ap = Popen("node " + environ['APPIUM_HOME'] + "\\node_modules\\appium\\lib\\server\\main.js" + " --port " + port + " --address " + host + " " + optional_args)
        except SocketServer.socket.error as socketer:
            logger.write(socketer)
        except OSError as e:
            logger.debug("OSError : " + e.errno)
            logger.debug("OSError : " + e.strerror)
            logger.debug("OSError : " + e.filename)
        except CalledProcessError:
            logger.write("subprocess called process error ")  # There was an error - command exited with non-zero code

        self.wait_for_appium(host, port)
        if self.is_running(host, port):
            running_al.add(alias)
            return ap  # does not need to return ap, just in case user wants to get process directly
        return self._bi.fail("Could not start appium server " + alias + " at port " + port + ", see error in log file")

    def wait_for_appium(self, host, port):
        waiting = 3
        while (not self.is_running(host, port)) and waiting <= 12:
            time.sleep(waiting)
            waiting += 3

    def wait_for_appium_to_stop(self, host, port):
        waiting = 3
        while (self.is_running(host, port)) and waiting <= 12:
            time.sleep(waiting)
            waiting += 3

    def is_running(self, host, port):
        """
        check if appium server on given adress is running, waits for ap to start
        - host      ip address
        - port      port number

        Returns True, False
        """
        content = None
        try:
            content = urllib2.urlopen('http://' + host + ':' + str(port) + '/wd/hub/status', timeout= 5).read(100)
        except urllib2.HTTPError, e:
            logger.debug('HTTPError = ' + str(e.code))
        except urllib2.URLError, e:
            logger.debug('URLError = ' + str(e.reason))
        except httplib.HTTPException, e:
            logger.debug('HTTPException')
        except Exception:
            import traceback
            logger.debug(str('generic exception: ' + traceback.format_exc()))
        if content is None:
            return False
        logger.info("got answer")
        return True

    def appium_should_be_running(self, alias):
        """
        uses is_running function
        - alias         device alias

        Returns True if appium runs, Test fails if appium does not run
        """
        host, port = self.get_device_args(alias)
        if self.is_running(host, port):
            return True
        return self._bi.fail("appium " + alias + " on address " + host + " : " + port + " is not running")

    def appium_should_not_be_running(self, alias):
        """
        uses is_running function, opposite of appium_should_be_running
        - alias      device alias

        Returns True if appium runs, Test fails if appium does not run
        """
        host, port = self.get_device_args(alias)
        if self.is_running(host, port):
            return self._bi.fail("appium " + alias + " on address " + host + " : " + port + " is running")
        return True

    def stop_appium(self, alias, port= None):
        """
        stops appium server, fails if appium wasnt running at first, or stopping was unsuccessful
        - alias       device alias
        - port:       user can specifiy port on which running appium should be stopped, can be used for stopping forgotten servers

        Returns void(pass) if appium stopped, fails if not stopped or wasnt running at the beginning of function
        """
        running_all = self._bi.get_variable_value("${running_aliases}")
        host, port2 = self.get_device_args(alias)
        if port is None:
            port = port2
        for conns in net_connections(kind='inet'):
            try:
                checkport = int(conns.laddr[1])
            except (AccessDenied, IndexError):
                checkport = 0
                pass
            if checkport == int(port):  # checking port, going through connections not processes => do not need to solve "system idle process" or others
                kill(int(conns[-1]), SIGTERM)
                self.wait_for_appium_to_stop(host, port)  # time to stop appium varies from 3 up to 30 seconds, therefore "dynamic" wait
                if self.is_running(host, port):
                    return self._bi.fail("Could not stop appium server " + alias + " at port " + port + ", see log file")
                running_all.discard(alias)  # remove alias from set of running aliases
                return
        return self._bi.fail("Could not stop appium server " + alias + " at port " + port + ", server was not running")


