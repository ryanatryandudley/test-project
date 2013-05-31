//
//  mkimage.m
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "mkimage.h"
#import "UIView+JSONInit.h"
#import "MKAssetLoader.h"

@implementation mkimage

mkitem_SYNTHESIZE();
mkitem_BASICDEALLOC();

-(id) initFromJsonDictionary:(NSMutableDictionary *)json {
	UIImage* image = [[MKAssetLoader sharedLoader] loadImage:json[@"file"]];
	// init the view with that image
	if (self = [self initWithImage:image])
		self = [super initFromJsonDictionary:json];
	return self;
}

@end
