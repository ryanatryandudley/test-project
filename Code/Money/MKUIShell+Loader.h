//
//  MKUIShell+Loader.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUIShell.h"

@interface MKUIShell (Loader)

// synchronously loads objects from a json file, file = path relative to asset bundle
+(NSMutableArray*) objectArrayFromJsonFile: (NSString*)file;
// synchronously loads objects from a json string, json = string
+(NSMutableArray*) objectArrayFromJsonString: (NSString*)json;
// synchronously loads objects from a json dictionary, dict = dictionary
+(NSMutableArray*) objectArrayFromJsonDictionary: (NSDictionary*)dict;

@end
