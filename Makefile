export TARGET = iphone:clang:11.4:11.0

include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = LockMyPlaylist

LockMyPlaylist_FILES = Tweak.xm
LockMyPlaylist_CFLAGS = -fobjc-arc
LockMyPlaylist_EXTRA_FRAMEWORKS = Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += tr1lockmyplaylistprefs

after-install::
	install.exec "sbreload"

include $(THEOS_MAKE_PATH)/aggregate.mk
