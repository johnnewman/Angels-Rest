//
//  JNLogger.h
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  JNLogger is a convenience class meant to be imported into
//  the app-wide prefix header.  LogMessage can be used in place
//  of NSLog for logging.  By flipping the kLOGGING_ON define,
//  you can disable all logging app-wide.
//

#import <Foundation/Foundation.h>

@interface JNLogger : NSObject

void LogMessage(NSString *message, ...);

@end
