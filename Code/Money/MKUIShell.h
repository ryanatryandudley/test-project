//
//  MKUIShell.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKUIShell : NSObject

// our ui items & command queue
@property (nonatomic, retain) NSMutableArray* items;
@property (nonatomic, retain) NSMutableArray* queue;
@property (nonatomic) BOOL locked;

// get the shared manager
+ (MKUIShell *) sharedShell;

// queue a command to run in the background
-(void) queueCommand: (NSDictionary*)command;
// queue multiple commands, simultaneously 
-(void) queueCommands: (NSArray*)commands;

@end
