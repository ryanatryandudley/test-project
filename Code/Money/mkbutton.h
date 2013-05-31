//
//  mkbutton.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mkitem.h"

@interface mkbutton : UIButton <mkitem>

// command to run if they click the button
@property (nonatomic, retain) id click;

@end
