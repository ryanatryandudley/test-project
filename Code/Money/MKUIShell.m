//
//  MKUIShell.m
//  Created by Ryan Dudley
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import "MKUIShell.h"
#import "MKUIShell+Loader.h"
#import "mkitem.h"
#import "UIView+JSONInit.h"

@implementation MKUIShell

static MKUIShell* sharedShell = nil;

// singleton
+ (MKUIShell *) sharedShell {
    @synchronized(self) {
        if (sharedShell == nil){
            sharedShell = [[self alloc] init];
        }
    }
    return sharedShell;
}

// init
- (id) init {
	self = [super init];
	if (self) {
		self.items = [NSMutableArray array];
		self.queue = [NSMutableArray array];
		self.locked = NO;
	}
	return self;
}

// always runs in background thread, executes the next command in the list
-(void) runNextCommand {
	// create a garbage collector
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// throw a loading indicator up
	UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	indicator.center = [UIApplication sharedApplication].keyWindow.center;
	[[UIApplication sharedApplication].keyWindow addSubview:indicator];
	[indicator startAnimating];
	
	// convert the command to a selector & execute it
	NSDictionary* cmd = self.queue[0];
	SEL func = NSSelectorFromString([NSString stringWithFormat:@"%@:",cmd[@"command"]]);
	if (func && [self respondsToSelector:func])
		[self performSelector:func withObject:cmd[@"params"]];
	
	// remove the object from the queue, we don't want to operate on the queue in multiple places
	BOOL runCommand = false;
	@synchronized(self.queue) {
		[self.queue removeObjectAtIndex:0];
		runCommand = (self.queue.count > 0);
		if (runCommand && self.queue[0][@"lock"])
			self.locked = [self.queue[0][@"lock"] boolValue];
		else
			self.locked = false;
	}
	
	// remove the loading indicator
	[indicator stopAnimating];
	[indicator removeFromSuperview];
		
	// continue execution if there's more to do
	if (runCommand)
		[self performSelectorInBackground:_cmd withObject:nil];
	
	// done with the garbage collector
	[pool release];
}

// queue a command to run
-(void) queueCommand:(NSDictionary *)command {
	[self queueCommands:[NSArray arrayWithObject:command]];
}

// copy over all commands
-(void) queueCommands: (NSArray*)commands {
	// don't allow commands to be queued while it's locked
	BOOL runCommand = false;
	// don't operate on the queue in multiple places
	@synchronized(self.queue) {
		if (self.locked)
			return;
		runCommand = (self.queue.count == 0);
		[self.queue addObjectsFromArray:commands];
		if (runCommand && self.queue[0][@"lock"])
			self.locked = [self.queue[0][@"lock"] boolValue];
	}
	// if no commands are running, we're free to go!
	if (runCommand)
		[self performSelectorInBackground:@selector(runNextCommand) withObject:nil];
}

@end
