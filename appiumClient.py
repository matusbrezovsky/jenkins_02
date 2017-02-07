from appium import webdriver

desired_caps = {
    'dontStopAppOnReset': False,
    'alias': u'MsPost2',
    'browserName': '',
    #'udid': u'80717aef8315',
    #'udid': u'0cd6bd1026ab',
    'udid': u'009acdb8031f',
    'deviceName': u'MsPost2',
    'platformVersion': '4.4',
    'appPackage': 'com.android.settings',
    'platformName': 'Android',
    'appActivity': '.HWSettings',
    'noReset': False,
    }

driver = webdriver.Remote('http://localhost:4724/wd/hub', desired_caps)
#el = driver.find_element_by_android_uiautomator('new UiSelector().text("Display")')
#el = driver.find_element_by_android_uiautomator('new UiScrollable(new UiSelector()).scrollForward()')
el = driver.find_element_by_android_uiautomator('new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().textContains("ttery"))')


driver.quit()
