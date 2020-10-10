TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = Preferences
ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Rimming

Rimming_FILES = Tweak.x
Rimming_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
