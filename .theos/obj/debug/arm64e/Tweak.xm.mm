#line 1 "Tweak.xm"
#import <LocalAuthentication/LocalAuthentication.h>
#include "Preferences/PSSpecifier.h"
#import <Foundation/NSUserDefaults.h>

static NSString *domainString = @"com.tr1fecta.lockmyplaylist";
NSString* playlistNames;


@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end



LAPolicy policy = LAPolicyDeviceOwnerAuthentication;
NSString *reason = @"Authentication Required";
BOOL authenticated;


void checkAuth(UITapGestureRecognizer* gestureRecognizer) {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    if (authenticated) {
        gestureRecognizer.cancelsTouchesInView = NO;
    }
    else {
        if ([context canEvaluatePolicy:policy error:&error]) {
            [context evaluatePolicy:policy localizedReason:reason reply:^(BOOL success, NSError *error) {
                if (success) {
                    authenticated = YES;
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

#line 44 "Tweak.xm"


static GLUEEntityRowContentView* _logos_method$_ungrouped$GLUEEntityRowContentView$initWithFrame$(_LOGOS_SELF_TYPE_INIT GLUEEntityRowContentView* __unused self, SEL __unused _cmd, CGRect arg1) _LOGOS_RETURN_RETAINED {
    id instance = _logos_orig$_ungrouped$GLUEEntityRowContentView$initWithFrame$(self, _cmd, arg1);

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    gestureRecognizer.delegate = instance;
    gestureRecognizer.cancelsTouchesInView = YES;
    [instance addGestureRecognizer:gestureRecognizer];


    return instance;
}



static void _logos_method$_ungrouped$GLUEEntityRowContentView$handleTap$(_LOGOS_SELF_TYPE_NORMAL GLUEEntityRowContentView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITapGestureRecognizer * gestureRecognizer) {
    

    
    
    
    
    NSLog(@"TWEAK ENABLED: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"playlistNames" inDomain:domainString]);
    if ([playlistNames isEqualToString:@"Playlist, Label Engine"]) {
        checkAuth(gestureRecognizer);
    }
    else {
        gestureRecognizer.cancelsTouchesInView = NO;
    }


}




static __attribute__((constructor)) void _logosLocalCtor_79b7d147(int __unused argc, char __unused **argv, char __unused **envp) {
    NSLog(@"PLAYLIST NAMES1: %@", playlistNames);
    if ([(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"tweakEnabled" inDomain:domainString] boolValue]) {
        playlistNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"playlistNames" inDomain:domainString];

    }
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$GLUEEntityRowContentView = objc_getClass("GLUEEntityRowContentView"); MSHookMessageEx(_logos_class$_ungrouped$GLUEEntityRowContentView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$GLUEEntityRowContentView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$GLUEEntityRowContentView$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITapGestureRecognizer *), strlen(@encode(UITapGestureRecognizer *))); i += strlen(@encode(UITapGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$GLUEEntityRowContentView, @selector(handleTap:), (IMP)&_logos_method$_ungrouped$GLUEEntityRowContentView$handleTap$, _typeEncoding); }} }
#line 89 "Tweak.xm"
