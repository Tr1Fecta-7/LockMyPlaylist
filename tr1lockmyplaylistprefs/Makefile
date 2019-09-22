include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e


BUNDLE_NAME = tr1lockmyplaylistprefs

tr1lockmyplaylistprefs_FILES = TLMPRootListController.m
tr1lockmyplaylistprefs_INSTALL_PATH = /Library/PreferenceBundles
tr1lockmyplaylistprefs_FRAMEWORKS = UIKit
tr1lockmyplaylistprefs_PRIVATE_FRAMEWORKS = Preferences
tr1lockmyplaylistprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
tr1lockmyplaylistprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/tr1lockmyplaylistprefs.plist$(ECHO_END)
