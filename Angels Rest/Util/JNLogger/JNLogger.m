//
//  JNLogger.m
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "JNLogger.h"

@implementation JNLogger

void LogMessage(NSString *message, ...)
{
#if kLOGGING_ON
    va_list optionalArgs;
    va_start(optionalArgs, message);
    va_end(optionalArgs);
    NSLogv(message, optionalArgs);
#endif
}

@end
