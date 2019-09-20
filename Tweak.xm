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
    /*(UILabel* playlistLabel = MSHookIvar<UILabel *>(self, "_titleLabel");

    if ([playlistLabel.text isEqualToString:@"Playlist"]) {
        checkAuth(gestureRecognizer);
    }*/

    NSLog(@"TWEAK ENABLED: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"playlistNames" inDomain:domainString]);
    if ([playlistNames isEqualToString:@"Playlist"]) {
        checkAuth(gestureRecognizer);
    }
    else {
        gestureRecognizer.cancelsTouchesInView = NO;
    }





}

%end


%ctor {
    NSLog(@"PLAYLIST NAMES1: SSSSSSSS");
    if ([(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"tweakEnabled" inDomain:domainString] boolValue]) {
        playlistNames = [[NSUserDefaults standardUserDefaults] objectForKey:@"playlistNames" inDomain:domainString];
        NSLog(@"TWEAK LOADEEEEEED AAA");
    }
}
