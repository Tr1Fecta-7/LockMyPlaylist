#line 1 "Tweak.xm"
#import <LocalAuthentication/LocalAuthentication.h>
#include "Preferences/PSSpecifier.h"
#import <Foundation/NSUserDefaults.h>

#define kIdentifier @"com.tr1fecta.lockmyplaylist"
#define kSettingsChangedNotification (CFStringRef)@"com.tr1fecta.lockmyplaylist/settingschanged"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.tr1fecta.lockmyplaylist.plist"

NSDictionary* prefs = nil;
NSString* playlistNamesString;
NSArray* playlistNamesArray;
BOOL tweakEnabled;
BOOL authEveryTimeEnabled;


static void reloadPrefs() {
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSDictionary new];
			}
			CFRelease(keyList);
		}
    }
    else {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}



static BOOL boolValueForKey(NSString *key, BOOL defaultValue) {
	return (prefs && [prefs objectForKey:key]) ? [[prefs objectForKey:key] boolValue] : defaultValue;
}

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    tweakEnabled = boolValueForKey(@"tweakEnabled", YES);
    authEveryTimeEnabled = boolValueForKey(@"authEveryTimeEnabled", NO);
    playlistNamesString = [prefs objectForKey:@"playlistNames"];

}


static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    preferencesChanged();
}


LAPolicy policy = LAPolicyDeviceOwnerAuthentication;
NSString *reason = @"Authentication Required";
BOOL authenticated;
int check_ForAuthEveryTime; 


void checkAuth(UITapGestureRecognizer* gestureRecognizer) {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    if (check_ForAuthEveryTime == 2 && authEveryTimeEnabled) {
        authenticated = NO;
        gestureRecognizer.cancelsTouchesInView = YES;
    }

    if (authenticated) {
        gestureRecognizer.cancelsTouchesInView = NO;
        check_ForAuthEveryTime = 2;
    }
    else {
        if ([context canEvaluatePolicy:policy error:&error]) {
            [context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError *error) {
                if (success) {
                    authenticated = YES;
                    check_ForAuthEveryTime = 1;
                }
                else {
                    authenticated = NO;
                }
            }];
        }
    }
}



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class GLUEEntityRowContentView; 
static GLUEEntityRowContentView* (*_logos_orig$_ungrouped$GLUEEntityRowContentView$initWithFrame$)(_LOGOS_SELF_TYPE_INIT GLUEEntityRowContentView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static GLUEEntityRowContentView* _logos_method$_ungrouped$GLUEEntityRowContentView$initWithFrame$(_LOGOS_SELF_TYPE_INIT GLUEEntityRowContentView*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static void _logos_method$_ungrouped$GLUEEntityRowContentView$handleTap$(_LOGOS_SELF_TYPE_NORMAL GLUEEntityRowContentView* _LOGOS_SELF_CONST, SEL, UITapGestureRecognizer *); 

#line 89 "Tweak.xm"


static GLUEEntityRowContentView* _logos_method$_ungrouped$GLUEEntityRowContentView$initWithFrame$(_LOGOS_SELF_TYPE_INIT GLUEEntityRowContentView* __unused self, SEL __unused _cmd, CGRect arg1) _LOGOS_RETURN_RETAINED {
    id instance = _logos_orig$_ungrouped$GLUEEntityRowContentView$initWithFrame$(self, _cmd, arg1);

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    gestureRecognizer.delegate = instance;
    gestureRecognizer.cancelsTouchesInView = YES;
    [instance addGestureRecognizer:gestureRecognizer];


    return instance;
}



static void _logos_method$_ungrouped$GLUEEntityRowContentView$handleTap$(_LOGOS_SELF_TYPE_NORMAL GLUEEntityRowContentView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITapGestureRecognizer * gestureRecognizer) {
    UILabel* playlistLabel = MSHookIvar<UILabel *>(self, "_titleLabel");


    for (NSString* playlist in playlistNamesArray) {
        if ([playlistLabel.text isEqualToString:playlist]) {
            checkAuth(gestureRecognizer);
        }
        else {
            gestureRecognizer.cancelsTouchesInView = NO;
        }
    }
}







static __attribute__((constructor)) void _logosLocalCtor_443d4de9(int __unused argc, char __unused **argv, char __unused **envp) {
    tweakEnabled = boolValueForKey(@"tweakEnabled", YES);
    if (tweakEnabled) {
        preferencesChanged();
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.tr1fecta.lock.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

        playlistNamesArray = [playlistNamesString componentsSeparatedByString:@", "];
    }


    

}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$GLUEEntityRowContentView = objc_getClass("GLUEEntityRowContentView"); MSHookMessageEx(_logos_class$_ungrouped$GLUEEntityRowContentView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$GLUEEntityRowContentView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$GLUEEntityRowContentView$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITapGestureRecognizer *), strlen(@encode(UITapGestureRecognizer *))); i += strlen(@encode(UITapGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GLUEEntityRowContentView, @selector(handleTap:), (IMP)&_logos_method$_ungrouped$GLUEEntityRowContentView$handleTap$, _typeEncoding); }} }
#line 140 "Tweak.xm"
