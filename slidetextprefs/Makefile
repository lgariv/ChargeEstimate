include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SlideTextPrefs

SlideTextPrefs_FILES = STPRootListController.m
SlideTextPrefs_INSTALL_PATH = /Library/PreferenceBundles
SlideTextPrefs_FRAMEWORKS = UIKit
SlideTextPrefs_PRIVATE_FRAMEWORKS = Preferences
SlideTextPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
SlideTextPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SlideTextPrefs.plist$(ECHO_END)
