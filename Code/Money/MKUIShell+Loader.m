//
//  MKUIShell+Loader.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKUIShell+Loader.h"
#import "mkitem.h"
#import <UIKit/UIKit.h>
#import "MKAssetLoader.h"

@implementation MKUIShell (Loader)

// load from json file
+(NSMutableArray*) objectArrayFromJsonFile: (NSString*)file {
	return [self objectArrayFromJsonFile:file withParent:nil];
}

// load from json string
+(NSMutableArray*) objectArrayFromJsonString: (NSString*)json {
	return [self objectArrayFromJsonString:json withParent:nil];
}

// load from json object
+(NSMutableArray*) objectArrayFromJsonDictionary: (NSDictionary*)dict {
	return [self objectArrayFromJsonDictionary:dict withParent:nil];
};

// load from json file
+(NSMutableArray*) objectArrayFromJsonFile: (NSString*)file withParent:(id<mkitem>)parent {
	return [self objectArrayFromJsonDictionary:[[MKAssetLoader sharedLoader] loadJson:file] withParent:parent];
}

// load from json string
+(NSMutableArray*) objectArrayFromJsonString: (NSString*)json withParent:(id<mkitem>)parent {
	// TODO: Strip comments out of json

	// load the json file
	NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
	
	// create the array
	NSMutableArray* arr = [self objectArrayFromJsonDictionary:dict withParent:parent];	
	return arr;
}

// return an array, creating all of our objects
+(NSMutableArray*) objectArrayFromJsonDictionary: (NSDictionary*)dict withParent: (id<mkitem>)parent {
	// first we create an intermediate array of dictionaries
	NSMutableArray* arr = [NSMutableArray arrayWithCapacity:[dict count]];
	[dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

		// force some default values
		NSMutableDictionary* d = [NSMutableDictionary dictionaryWithDictionary:obj];
		// copy over the name
		d[@"name"] = key;
		// copy the parent to assign
		if (parent)
			d[@"parent"] = parent;
		// force an order param
		if (!d[@"order"])
			d[@"order"] = [NSNumber numberWithInt:0];
		// force user interactable
		if (!d[@"userInteractionEnabled"])
			d[@"userInteractionEnabled"] = [NSNumber numberWithBool:YES];
		// force clipping
		if (!d[@"clipsToBounds"])
			d[@"clipsToBounds"] = [NSNumber numberWithBool:YES];
		// force autoresize
		/*if (!d[@"autoresizesSubviews"])
			d[@"autoresizesSubviews"] = [NSNumber numberWithBool:NO];
		if (!d[@"autoresizingMask"])
			d[@"autoresizingMask"] = [NSNumber numberWithInt:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];*/
		// force parentless objects to resize to the parent
		if (!d[@"resizeToParent"])
			d[@"resizeToParent"] = [NSNumber numberWithBool:!parent];
		if (!d[@"resizeToChildren"])
			d[@"resizeToChildren"] = [NSNumber numberWithBool:NO];
		
		[arr addObject:d];
	}];
	
	// now we sort them
	[arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [obj2[@"order"] compare:obj1[@"order"]];
	}];
	
	// now we create & return
	NSMutableArray* objects = [NSMutableArray array];
	for (NSMutableDictionary* d in arr) {
		// figure out the class name
		NSString* class = [NSString stringWithFormat:@"mk%@", [d[@"class"] lowercaseString]];
		// create the object
		id<mkitem> item = [[[NSClassFromString(class) alloc] performSelector:@selector(initFromJsonDictionary:) withObject:d] autorelease];
		// skip garbage
		if (!item)
			continue;
		// add it to the list
		[objects addObject:item];
		
		// recurse on children
		id children = d[@"children"];
		if (children) {
			// if it's a file we load the file
			if ([children isKindOfClass:[NSString class]])
				[objects addObjectsFromArray:[self objectArrayFromJsonFile:children withParent:item]];
			else
				[objects addObjectsFromArray:[self objectArrayFromJsonDictionary:children withParent:item]];
		}
	};
		
	return objects;
}

@end
