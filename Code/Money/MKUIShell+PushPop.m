//
//  MKUIShell+PushPop.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKUIShell+PushPop.h"
#import "MKUIShell+Loader.h"
#import "UIView+JSONInit.h"
#import "mkitem.h"

@implementation MKUIShell (PushPop)

// loads a screen from a json file
-(void) pushItem: (NSString*)file withParent:(UIView*)parent {
	NSMutableArray* a = [[self class] objectArrayFromJsonFile:file];
	
	// attach the top-most object in the json to the parent view
	for (int i = [a count]-1; i >= 0; --i) {
		UIView<mkitem>* item = a[i];
		
		// resize an item to fit it's children
		if (item.resizeToChildren) {
			NSArray* kids = [a filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
				return ((UIView<mkitem>*)evaluatedObject).parent == item;
			}]];
			
			CGSize s = [UIView frameSizeOfArray:kids];
			if ([item isKindOfClass:[UIScrollView class]])
				((UIScrollView*)item).contentSize = s;
			else
				item.frame = (CGRect){ item.frame.origin.x, item.frame.origin.y, s.width, s.height };
		}
		
		// add all the objects to their parent view
		[item addToParentOrMainView: parent];
		
		// resize the item to it's parent view
		if (item.resizeToParent) {
			CGRect b = [[item superview] bounds];
			CGSize scale = (CGSize){ b.size.width/item.frame.size.width, b.size.height/item.frame.size.height };
			CGSize o = item.frame.size;
			item.transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformTranslate(item.transform, -o.width/2.f, -o.height/2.f), scale.width, scale.height), o.width/2.f, o.height/2.f);
		}
	}
	@synchronized(self.items) {
		[self.items addObjectsFromArray:a];
	}
}

// add a screen onto every screen with the specified tag
-(void) push: (NSDictionary*)params {
	if (params[@"to"]) {
		for (int i = 0; i < [self.items count]; ++i) {
			UIView<mkitem>* item = self.items[i];
			if ([item.name isEqualToString:params[@"name"]]) {
				[self pushItem:params[@"file"] withParent:item];
			}
		}
	}
	// no parent, push to main
	else
		[self pushItem:params[@"file"] withParent:nil];
}

// recursively remove all subviews from the hierarchy
-(void) removeObjectFromAll: (UIView*)view {
	while ([view.subviews count] > 0) {
		[self removeObjectFromAll:view.subviews[0]];
	}
	[view removeFromSuperview];
	@synchronized (self.items) {
		[self.items removeObject:view];
	}
}

// remove all items with the passed name from the hierarchy (and their children)
-(void) popItem: (NSString*)tag {
	// count backwards so we don't lose our spot in the array
	for (int i = [self.items count]-1; i >= 0; --i) {
		if ([((id<mkitem>)self.items[i]).name isEqualToString:tag]) {
			[self removeObjectFromAll:self.items[i]];
		}
	}
}

// remove an item with params wrapped in dictionary
-(void) pop: (NSDictionary*)params {
	[self popItem:params[@"name"]];
}

@end
