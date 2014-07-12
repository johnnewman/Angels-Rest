//
//  JNImageCacher.h
//  Angels Rest
//
//  Created by John Newman on 7/8/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//
//  JNImageCacher is a singleton used for downloading images
//  in the background and notifying the caller when completed
//  using blocks.  It caches all downloaded images in a thread
//  save NSCache.  After the inital download, images are
//  pulled from the cache (using the URL as the key) and the
//  completion block is called immediately.
//

#import <Foundation/Foundation.h>

typedef void (^JNImageCacherCompletionBlock)(UIImage *image, NSString *urlString);

@interface JNImageCacher : NSObject

@property (nonatomic, strong) NSCache *imageCache;

+ (JNImageCacher *)sharedInstance;
- (void)getImage:(NSString *)urlString completionHandler:(JNImageCacherCompletionBlock)handler;

@end
