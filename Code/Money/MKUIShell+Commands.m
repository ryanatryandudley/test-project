//
//  MKUIShell+Commands.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKUIShell+Commands.h"
#import "mkitem.h"

@implementation MKUIShell (Commands)

// call a function on our item list that matches tag
-(void) callFunction:(SEL)func onTag:(NSString*)name withObject:(id)obj {
	for (int i = 0; i < [self.items count]; ++i) {
		UIView<mkitem>* item = self.items[i];
		if ([item.name isEqualToString:name] && [item respondsToSelector:func])
			[item performSelector:func withObject:obj];
	}
}

// enable an item with params wrapped in dictionary
-(void) enable: (NSDictionary*)params {
	[self callFunction:@selector(setEnabled:) onTag:params[@"name"] withObject:(id)YES];
}

// enable an item with params wrapped in dictionary
-(void) disable: (NSDictionary*)params {
	[self callFunction:@selector(setEnabled:) onTag:params[@"name"] withObject:(id)NO];
}

// show an item with params wrapped in dictionary
-(void) show: (NSDictionary*)params {
	[self callFunction:@selector(setHidden:) onTag:params[@"name"] withObject:(id)NO];
}

// hide an item with params wrapped in dictionary
-(void) hide: (NSDictionary*)params {
	[self callFunction:@selector(setHidden:) onTag:params[@"name"] withObject:(id)YES];
}

@end
