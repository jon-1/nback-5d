//
//  DebugConstants.h
//  nback5d
//
//  Created by Candy on 12/24/15.
//  Copyright © 2015 jon-1. All rights reserved.
//

#ifndef DebugConstants_h
#define DebugConstants_h

#endif

#define DEBUGGING

#ifdef DEBUGGING
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog( s, ...)
#endif


