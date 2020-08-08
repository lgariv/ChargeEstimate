export ARCHS = arm64 arm64e
TARGET = iphone:clang:13.5

FINALPACKAGE=1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk
 
TWEAK_NAME = ChargeEstimate

ChargeEstimate_FILES = Tweak.xm
ChargeEstimate_FRAMEWORKS = UIKit IOKit
ChargeEstimate_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
