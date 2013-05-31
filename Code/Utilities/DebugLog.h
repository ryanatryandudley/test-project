//
//  DebugLog.h
//  ZombieJombie
//
//  Created by Ally Ogilvie
//  Copyright (c) 2011 WizCorp Inc. All rights reserved.
//

#ifndef NDEBUG
#define DLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif