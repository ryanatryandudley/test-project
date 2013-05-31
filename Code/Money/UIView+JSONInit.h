//
//  NSObject+JSONInit.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (JSONInit)

// you must call an init function for your class PRIOR to this
-(id) initFromJsonDictionary: (NSMutableDictionary*)json;
// adds this object to it's parent if specified, otherwise to the main view
-(void) addToParentOrMainView: (UIView*)parent;
// calcutate the frame size of the passed array
+ (CGSize) frameSizeOfArray: (NSArray*)views;

@end
