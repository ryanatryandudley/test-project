//
//  MKServerSelection.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKServerSelection : NSObject

// force a selection
+(void) pickServer:(void(^)(NSString* selection))onSelect;

// just grabs the selected server
+(NSString*) getServer;

@end
