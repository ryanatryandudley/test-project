//
//  mkbutton.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "mkbutton.h"
#import "UIView+JSONInit.h"
#import "MKUIShell.h"
#import "mkimage.h"
#import "MKAssetLoader.h"

@implementation mkbutton

mkitem_SYNTHESIZE();

-(id) initFromJsonDictionary:(NSMutableDictionary *)json {
	// init
	if (self = [self init]) {
		self = [super initFromJsonDictionary:json];
	
		// add normal image
		UIImage* n = [[MKAssetLoader sharedLoader] loadImage:json[@"n_file"]];
		if (n) [self setImage:n forState:UIControlStateNormal];
		// add highlighted image
		UIImage* h = [[MKAssetLoader sharedLoader] loadImage:json[@"h_file"]];
		if (h) [self setImage:h forState:UIControlStateHighlighted];
		// add disabled image
		UIImage* d = [[MKAssetLoader sharedLoader] loadImage:json[@"d_file"]];
		if (d) [self setImage:d forState:UIControlStateDisabled];
				
		// make the images stretch
		self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
		self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
		
		// add click handler
		if (self.click)
			[self addTarget:self action:@selector(buttonClick:withEvent:) forControlEvents:UIControlEventTouchUpInside];
	}
		
	return self;
}

// on click, this will queue the command
- (void) buttonClick: (id)sender withEvent: (id)event {
	if ([self.click isKindOfClass:[NSArray class]])
		[[MKUIShell sharedShell] queueCommands:self.click];
	else if ([self.click isKindOfClass:[NSDictionary class]])
		[[MKUIShell sharedShell] queueCommand:self.click];
}

-(void) dealloc {
	self.click = nil;
	mkitem_DEALLOC();
	[super dealloc];
}

@end
