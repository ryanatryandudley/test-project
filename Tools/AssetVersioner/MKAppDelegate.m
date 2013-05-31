//
//  MKAppDelegate.m
//  AssetVersioner
//
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKAppDelegate.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MKAppDelegate

// sha256 of a 
-(NSString*)sha256:(NSData*)data {
	unsigned char b[CC_SHA256_DIGEST_LENGTH];
	CC_SHA256([data bytes], (unsigned)[data length], b);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15],
			b[16], b[17], b[18], b[19], b[20], b[21], b[22], b[23], b[24], b[25], b[26], b[27], b[28], b[29], b[30], b[31]];
}

-(void) applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSMutableDictionary* map = [NSMutableDictionary dictionary];
	NSFileManager* manager = [[[NSFileManager alloc] init] autorelease];
	NSDirectoryEnumerator* enumerator = [manager enumeratorAtPath:[[NSBundle mainBundle] resourcePath]];
	for (NSString* path in enumerator) {
		BOOL isDir = false;
		NSString* fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
		if ([manager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
			NSData* data = [NSData dataWithContentsOfFile:fullPath];
			NSString* savePath = [[[path stringByDeletingPathExtension] stringByAppendingPathComponent:[self sha256:data]] stringByAppendingPathExtension:[path pathExtension]];
			map[path] = savePath;
		}
	}
	
	// open a dialog for selecting the asset directory
	NSSavePanel* dialog = [NSSavePanel savePanel];
	dialog.title = @"Select save directory";
	dialog.canCreateDirectories = YES;
	dialog.allowedFileTypes = [NSArray arrayWithObject:@"plist"];
	dialog.allowsOtherFileTypes = NO;
	dialog.nameFieldStringValue = @"AssetVersionMap.plist";
	[dialog beginWithCompletionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton) {
			[map writeToURL:dialog.URL atomically:NO];
			[[NSApplication sharedApplication] terminate:self];
		}
	}];
}

@end
