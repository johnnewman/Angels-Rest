//
//  JNImageCacher.m
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "JNImageCacher.h"

static JNImageCacher *sharedCacher;

@implementation JNImageCacher

+ (JNImageCacher *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCacher = [[JNImageCacher alloc] init];
    });
    return sharedCacher;
}

- (id)init
{
    if (self = [super init])
    {
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)getImage:(NSString *)urlString completionHandler:(JNImageCacherCompletionBlock)handler
{
    UIImage *thumbnailImage = [_imageCache objectForKey:urlString];
    if (thumbnailImage == nil)
    {
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            UIImage *thumbnail = [UIImage imageWithData:imageData];
            [weakSelf.imageCache setObject:thumbnail forKey:urlString];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(thumbnail, urlString);
            });
        });
    }
    else
    {
        handler(thumbnailImage, urlString);
    }
}

@end
