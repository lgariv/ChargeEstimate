export ARCHS = arm64 arm64e
//export THEOS_DEVICE_IP = 172.20.10.1
//export THEOS_DEVICE_IP = 192.168.1.217
export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
TARGET = iphone:clang:latest

//FINALPACKAGE=1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SlideText

SlideText_FRAMEWORKS = IOKit
SlideText_FILES = Tweak.xm
SlideText_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += slidetextprefs
//SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
