//
//  MKViewController.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKViewController.h"
#import "MKUIShell.h"

@implementation MKViewController

// execute the command from the console if possible
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSError* err = nil;
	NSDictionary* command = [NSJSONSerialization JSONObjectWithData:[textField.text dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
	if (!err && command)
		[[MKUIShell sharedShell] queueCommand:command];
	textField.text = @"";
	[textField resignFirstResponder];
	return NO;
}

// i tagged 999999 as the pass-through uiview
- (void) viewWillLayoutSubviews {
	for (UIView* view in self.view.subviews) {
		if (view.tag == 999999)
			[self.view bringSubviewToFront:view];
	}
}

@end
