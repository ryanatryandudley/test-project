//
//  MKServerSelection.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKServerSelection.h"
#import "ServerSelectionView.h"

// saves in the defaults under this key
#define mkServerSelection @"mkServerSelection"

static NSString* _selectedServer = nil;

@implementation MKServerSelection

// must be called before we try to get the server
+(void) pickServer:(void(^)(NSString* selection))onSelect {
	// load the server plist
	NSString *serverPlist = [NSString stringWithFormat:@"%@/servers.plist", [[NSBundle mainBundle] bundlePath]];
	NSDictionary* servers = [NSDictionary dictionaryWithContentsOfFile:serverPlist];
	
	// create a block to call for the server selector
	void(^ret)(NSString*,BOOL) = ^(NSString* selection, BOOL save) {
		_selectedServer = [servers[@"servers"][selection] retain];
		onSelect(_selectedServer);
		
		// save to the defaults so we don't need to check in the future
		if (save) {
			NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
			[def setObject:selection forKey:mkServerSelection];
			[def synchronize];
		}
	};
	
	// check if we're defaulting to prod, if we are, we're done
	if ([servers[@"selection"] isEqualToString:@"production"]) {
		ret(@"production", NO);
		return;
	}
	
	// check if we've already saved a value
	NSString* saved = [[NSUserDefaults standardUserDefaults] objectForKey:mkServerSelection];
	if (saved && servers[@"servers"][saved])
		ret(saved, NO);
	// otherwise we need to launch the selector
	else {
		ServerSelectionView* selector = [ServerSelectionView serverSelectionView:servers[@"servers"] onSelect:ret];
		[[UIApplication sharedApplication].delegate.window setRootViewController:selector];
		[[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
	}
}

+(NSString*) getServer {
	return _selectedServer;
}

@end
