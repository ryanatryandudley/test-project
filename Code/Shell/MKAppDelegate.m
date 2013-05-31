//
//  MKAppDelegate.m
//  Created by Ryan Dudley
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKViewController.h"
#import "MKServerSelection.h"
#import "MKUIShell.h"

@implementation MKAppDelegate

- (void)dealloc {
	[_window release];
	[_viewController release];
    [super dealloc];
}

// entry point for the application
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.viewController = [[[MKViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	
	// executes server picker
	[MKServerSelection pickServer:^(NSString *selection) {
		self.window.rootViewController = self.viewController;
		[self.window makeKeyAndVisible];
		// load the scenes
		[[MKUIShell sharedShell] queueCommand:@{@"command": @"push", @"params": @{ @"file": @"assets/gamescene/scene.json"} }];
	}];
		
    return YES;
}

@end
