//
//  MKPassView.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKPassView.h"

@implementation MKPassView

// allow clicks to pass through unless they are within our subviews
-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
	[self.subviews[0] resignFirstResponder];
    return NO;
}

@end
