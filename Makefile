export ARCHS = arm64 arm64e
#TARGET = iphone:clang:13.1

#FINALPACKAGE=1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SlideText

SlideText_FRAMEWORKS = IOKit
SlideText_FILES = Tweak.xm
SlideText_FRAMEWORKS = UIKit
SlideText_PRIVATE_FRAMEWORKS = IOKit
SlideText_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += slidetextprefs
//SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
