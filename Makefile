PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = xelahotmodmenubase

xelahotmodmenubase_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
xelahotmodmenubase_CFLAGS = -fobjc-arc #-w #-Wno-deprecated -Wno-deprecated-declarations
xelahotmodmenubase_FILES = Tweak.xm Page.mm Menu.mm MenuItem.mm ToggleItem.mm PageItem.mm SliderItem.mm TextfieldItem.mm InvokeItem.mm
xelahotmodmenubase_FRAMEWORKS = UIKit
# GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
