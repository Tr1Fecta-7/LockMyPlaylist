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
int check_ForAuthEveryTime; // 1 = non auth, 2 = auth


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


%hook GLUEEntityRowContentView

-(id)initWithFrame:(CGRect)arg1 {
    id instance = %orig;

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    gestureRecognizer.delegate = instance;
    gestureRecognizer.cancelsTouchesInView = YES;
    [instance addGestureRecognizer:gestureRecognizer];


    return instance;
}


%new
-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
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

%end





%ctor {
    tweakEnabled = boolValueForKey(@"tweakEnabled", YES);
    if (tweakEnabled) {
        preferencesChanged();
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("com.tr1fecta.lock.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

        playlistNamesArray = [playlistNamesString componentsSeparatedByString:@", "];
    }


    //NSLog(@"TWEAK LOADED: PLAYLISTNAME:%@", playlistNamesArray[1]);

}
