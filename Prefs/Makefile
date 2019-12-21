TARGET = :clang:11.2:7.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SlidePrefsTest
SlidePrefsTest_FILES = SlidePrefsTestRootListController.mm $(wildcard *.m)
SlidePrefsTest_INSTALL_PATH = /Library/PreferenceBundles
SlidePrefsTest_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
SlidePrefsTest_PRIVATE_FRAMEWORKS = Preferences
SlidePrefsTest_LDFLAGS = -lMobileGestalt
SlidePrefsTest_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SlidePrefsTest.plist$(ECHO_END)
