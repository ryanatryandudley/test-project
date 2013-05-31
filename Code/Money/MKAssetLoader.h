//
//  MKAssetLoader.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface MKAssetLoader : NSObject {
	NSDictionary* _assetVersionMap;
}

// get the shared manager
+ (MKAssetLoader *) sharedLoader;

// Synchronously load objects
-(NSData*) loadData: (NSString*)path;
// handles json conversion
-(NSDictionary*) loadJson: (NSString*)path;
// handles image conversion, returns a default on failure
-(UIImage*) loadImage: (NSString*)path;

// Asynchronously load objects (not implemented yet)
-(void) loadData: (NSString*)path onComplete:(void (^)(NSData* result))block;
-(void) loadJson: (NSString*)path onComplete:(void (^)(NSDictionary* result))block;
-(void) loadImage: (NSString*)path onComplete:(void (^)(UIImage* result))block;

// TODO: add sound

@end
