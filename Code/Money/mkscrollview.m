//
//  mkscrollview.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "mkscrollview.h"
#import "UIView+JSONInit.h"

@implementation mkscrollview

mkitem_BASICINIT();
mkitem_BASICDEALLOC();

// interpret size as content size
-(void) setSize:(NSDictionary*)contentSize {
	self.contentSize = (CGSize){ [contentSize[@"w"] floatValue], [contentSize[@"h"] floatValue] };
}

@end
