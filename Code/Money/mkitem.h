//
//  mkitem.h
//  Created by Ryan Dudley
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mkitem <NSObject>

// basic properties all objects have
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) UIView<mkitem>* parent;
@property (nonatomic) BOOL resizeToParent;
@property (nonatomic) BOOL resizeToChildren;

-(id) initFromJsonDictionary:(NSMutableDictionary *)json;

@end

// synthesize the properties
#define mkitem_SYNTHESIZE() @synthesize name, parent, resizeToParent, resizeToChildren;
#define mkitem_DEALLOC() self.name = nil
// define a basic initialization function
#define mkitem_BASICINIT() mkitem_SYNTHESIZE(); \
-(id) initFromJsonDictionary:(NSMutableDictionary *)json { if (self = [self init]) { self = [super initFromJsonDictionary:json]; } return self; }
// define a basic deallocation function
#define mkitem_BASICDEALLOC() -(void) dealloc { mkitem_DEALLOC(); [super dealloc]; }
