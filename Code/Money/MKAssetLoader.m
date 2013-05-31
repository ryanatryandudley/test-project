//
//  MKAssetLoader.m
//  Created by Ryan Dudley
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKAssetLoader.h"
#import <UIKit/UIKit.h>
#import "DebugLog.h"
#import "MKServerSelection.h"

#define mkBaseAssetDirectory @"assets"
#define mkAssetVersioningPath @"assets/AssetVersionMap.plist"

// if this is defined, we bypass the versioning system
#define BYPASSVERSIONING false

@implementation MKAssetLoader

static MKAssetLoader* sharedLoader = nil;

// get the shared manager
+ (MKAssetLoader *) sharedLoader {
    @synchronized(self) {
        if (sharedLoader == nil){
            sharedLoader = [[self alloc] init];
        }
    }
    return sharedLoader;
}

// convert the path to a versioned path
-(NSString*) versionPathFromPath: (NSString*)path {
	// this is for debugging purposes - skip versioning
	if (BYPASSVERSIONING)
		return path;
	// make sure we have a version map
	if (!_assetVersionMap) {
		// we first check online for this one
		NSString* url = [NSString stringWithFormat:@"%@%@", [MKServerSelection getServer], mkAssetVersioningPath];
		NSString* file = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:mkAssetVersioningPath];
		_assetVersionMap = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:url]];
		if (_assetVersionMap) {
			// if we downloaded it, save it
			NSError* err = nil;
			NSFileManager* manager = [[[NSFileManager alloc] init] autorelease];
			if ([manager createDirectoryAtPath:[file stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&err] && !err)
				[_assetVersionMap writeToFile:file atomically:NO];
		}
		// failed to download, check for it in the cache
		if (!_assetVersionMap)
			_assetVersionMap = [NSDictionary dictionaryWithContentsOfFile:file];
		// not in the cache, check for it in the bundle
		if (!_assetVersionMap)
			_assetVersionMap = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: mkAssetVersioningPath]];
		// this should not happen...
		if (!_assetVersionMap) {
			DLog(@"Completely failed to load asset versioning map, hopefully the file just exists...");
			return path;
		}
		[_assetVersionMap retain];
	}
	return _assetVersionMap[path];
}

// Synchronously load data
-(NSData*) loadData: (NSString*)path {	
	// load the data synchronously
	NSError* err = nil;
	
	NSString* convertedPath = [self versionPathFromPath:path];
	// first attempt is to load from the binary
	NSString* file = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:convertedPath];
	NSData* ret = [NSData dataWithContentsOfFile:file options:NSDataReadingMappedIfSafe error:&err];
	if (!err && ret)
		return ret;
	err = nil;
	
	// second attempt is to load from the cache
	file = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:convertedPath];
	ret = [NSData dataWithContentsOfFile:file options:NSDataReadingMappedIfSafe error:&err];
	if (!err && ret)
		return ret;
	err = nil;
	
	// finally we need to download the file
	NSString* url = [NSString stringWithFormat:@"%@%@",[MKServerSelection getServer],path];
	ret = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&err];
	if (!err && ret) {
		// if its successful, we save it in the cache
		NSFileManager* manager = [[[NSFileManager alloc] init] autorelease];
		[manager removeItemAtPath:[file stringByDeletingLastPathComponent] error:nil];
		if ([manager createDirectoryAtPath:[file stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&err] && !err)
			[ret writeToFile:file atomically:NO];
		return ret;
	}
	
	// error in data download
	DLog(@"Error in synchronous load of data: %@, Error: %@", url, err);
	return nil;
}

// load a json, handles conversion
-(NSDictionary*) loadJson: (NSString*)path {
	// we don't want anything if no path is specified
	if (!path)
		return nil;
	
	// load base data
	NSData* data = [self loadData:path];
	if (!data)
		return nil;

	// run the conversion
	NSError* err = nil;
	NSDictionary* ret = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
	if (!err && ret)
		return ret;
	
	// json failure
	DLog(@"Error in synchronous load of data: %@, Error: %@", path, err);
	return nil;
}

// load an image, handles conversion
-(UIImage*) loadImage: (NSString*)path {
	// we don't want anything if no path is specified
	if (!path)
		return nil;
	
	// if we load something, return the image
	NSData* data = [self loadData:path];
	if (data)
		return [UIImage imageWithData:data];
	
	// otherwise return a default image
	NSString* fnf = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:mkBaseAssetDirectory] stringByAppendingPathComponent:@"img/fnf.png"];
	data = [NSData dataWithContentsOfFile:fnf];
	return [UIImage imageWithData:data];
}

// Asynchronously load objects, async
-(void) loadData: (NSString*)path onComplete:(void (^)(NSData* result))block {
}

// load a json, handles conversion, async
-(void) loadJson: (NSString*)path onComplete:(void (^)(NSDictionary* result))block {
}

// load an image, handles conversion, async
-(void) loadImage: (NSString*)path onComplete:(void (^)(UIImage* result))block {
}

@end
