//
//  NSObject+JSONInit.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "UIView+JSONInit.h"
#import "mkitem.h"

@implementation UIView (JSONInit)

// this will call nsobject's implementation
-(id) initFromJsonDictionary:(NSMutableDictionary *)json {
	// base init
	self = [self automaticInit:json];
	// handle frame
	[self setFrameWithJson:json[@"rect"]];
	
	return self;
}

// if we have a parent view, we add it
-(void) addToParentOrMainView: (UIView*)parent {
	UIView<mkitem>* me = (UIView<mkitem>*)self;
	// if we have a parent, add it, otherwise, don't
	if (me.parent)
		[me.parent addSubview:me];
	else if (parent)
		[parent addSubview:me];
	else
		[[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:me];
}

// set the frame if we can
-(void) setFrameWithJson:(NSDictionary*)p {
	// they specified a frame
	if (p) {
		NSNumber* x = p[@"x"], * y = p[@"y"], * w = p[@"w"], * h = p[@"h"];
		self.frame = (CGRect){
			x ? [x floatValue] : 0.f, y ? [y floatValue] : 0.f,
			w ? [w floatValue] : self.frame.size.width, h ? [h floatValue] : self.frame.size.height
		};
	}
	// use the parent
	else if (((UIView<mkitem>*)self).parent)
		self.frame = ((UIView<mkitem>*)((UIView<mkitem>*)self).parent).frame;
	// parent is the root, we use it's bounds because it could be rotated
	else
		self.frame = [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] bounds];
}

// calculate size based on a list of objects
+ (CGSize) frameSizeOfArray: (NSArray*)views {
	float w = 0.f, h = 0.f;
	for (UIView *v in views) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
	return (CGSize){w, h};
}


// this does all the automatic initialization of properties
-(id) automaticInit:(NSMutableDictionary *)json {
	// see if there is a setter function for any of our properties
	for (NSString* key in json) {
		// figure out the property setter function
		NSString* first = [key substringToIndex:1];
		NSString* selector = [NSString stringWithFormat:@"set%@%@:", [first uppercaseString], [key substringFromIndex:1]];
		
		// see if the function exists
		SEL func = NSSelectorFromString(selector);
		if (func && [self respondsToSelector:func]) {
			id obj = json[key];
			// we have to do something special for built-in types
			if ([obj isKindOfClass:[NSNumber class]]) {
				// I'm converting built-in types to a pointer address
				NSNumber* mask;
				const char* type = [obj objCType];
				switch (type[0]) {
						// c is bool
					case 'c':
						mask = (NSNumber*)[obj boolValue];
						break;
						// i is int
					case 'i':
						mask = (NSNumber*)[obj intValue];
						break;
						// I is NSInteger
					case 'I':
						mask = (NSNumber*)[obj integerValue];
						break;
						// for floats (f) & doubles (d), it gets a little weird
					case 'f':
					case 'd':
						// this will only work if we can memcopy to an int
						if (sizeof(float) == sizeof(int)) {
							int storage;
							float actual = [obj floatValue];
							memcpy(&storage, &actual, sizeof(int));
							mask = (NSNumber*)storage;
							break;
						}
						// in fallout, we skip it
					default:
						continue;
				}
				obj = mask;
			}
			[self performSelector:func withObject:obj];
		}
	}
	return self;
}

@end
