//
//  MKViewController.h
//  Created by Ryan Dudley 
//  Copyright (c) 2013 Ryan Dudley All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKViewController : UIViewController <UITextFieldDelegate>

// command console window
@property (nonatomic, assign) IBOutlet UITextField* consoleText;

@end
