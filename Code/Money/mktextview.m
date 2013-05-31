//
//  mktextview.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "mktextview.h"
#import "UIView+JSONInit.h"

@implementation mktextview

mkitem_BASICINIT();
mkitem_BASICDEALLOC();

// interpret font from json
-(void) setFont:(NSDictionary*)font {
	if ([font isKindOfClass:[UIFont class]])
		[super setFont:(UIFont*)font];
	else
		[super setFont:[UIFont fontWithName:font[@"name"] size:[font[@"size"] floatValue]]];
}

// interpret color from json
-(void) setTextColor: (NSDictionary*)color {
	if ([color isKindOfClass:[UIColor class]])
		[super setTextColor:(UIColor*)color];
	else
		[super setTextColor:[UIColor colorWithRed:[color[@"r"] floatValue] green:[color[@"g"] floatValue] blue:[color[@"b"] floatValue] alpha:[color[@"a"] floatValue]]];
}

// interpret background color from json
-(void) setBackgroundColor: (NSDictionary*)color {
	if ([color isKindOfClass:[UIColor class]])
		[super setBackgroundColor:(UIColor*)color];
	else
		[super setBackgroundColor:[UIColor colorWithRed:[color[@"r"] floatValue] green:[color[@"g"] floatValue] blue:[color[@"b"] floatValue] alpha:[color[@"a"] floatValue]]];
}

@end
