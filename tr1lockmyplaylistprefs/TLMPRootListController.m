#include "TLMPRootListController.h"

#import <spawn.h>

@implementation TLMPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)refresh:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),  CFSTR("com.tr1fecta.lockmyplaylist.settingschanged"), nil, nil, true);
}

-(void)respring{
	pid_t pid;
	const char* args[] = {"killall", "-9", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

@end
