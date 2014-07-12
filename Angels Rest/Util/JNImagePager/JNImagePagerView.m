//
//  JNImagePagerView.h
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "JNImagePagerView.h"
#import <QuartzCore/QuartzCore.h>

@interface JNImagePagerView ()
@end

@implementation JNImagePagerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performInitialViewSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self performInitialViewSetup];
}

- (void)performInitialViewSetup
{
    self.clipsToBounds = YES;
    NSUInteger imageCount = 0;
    if ([_dataSource respondsToSelector:@selector(numberOfImagesInImagePagerView:)])
        imageCount = [_dataSource numberOfImagesInImagePagerView:self];
    
    [self setupScrollView:imageCount];
    [self setupImageViews:imageCount];
}


#pragma mark - View Setup

- (void)setupScrollView:(NSUInteger)imageCount
{
    imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    imageScrollView.delegate = self;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.contentSize = CGSizeMake((self.bounds.size.width * imageCount), self.bounds.size.height);
    [self addSubview:imageScrollView];
}

//Creates imageCount number of image views in the scroll view.  Also
//  adds activity indicators to the center of each image view.  The
//  indicators automatically animate until setImage:forIndex: is
//  called.
- (void)setupImageViews:(NSUInteger)imageCount
{
    imageViews = [NSMutableArray arrayWithCapacity:imageCount];
    activityIndicators = [NSMutableArray arrayWithCapacity:imageCount];
    for (NSUInteger i = 0; i < imageCount; i++)
    {
        CGRect imageViewRect = CGRectMake(self.bounds.size.width * i, 0, self.bounds.size.width, self.bounds.size.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        imageView.clipsToBounds = YES;
        if ([_dataSource respondsToSelector:@selector(imagePagerView:contentModeForImageIndex:)])
            imageView.contentMode = [_dataSource imagePagerView:self contentModeForImageIndex:i];
        else
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [imageViews addObject:imageView];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = imageView.center;
        activityIndicator.hidesWhenStopped = YES;
        [imageScrollView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicators addObject:activityIndicator];
    }
}


#pragma mark - Public Control Methods

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated
{
    _currentPage = page;
    CGSize pageSize = self.bounds.size;
    [imageScrollView scrollRectToVisible:CGRectMake(pageSize.width * page, 0, pageSize.width, pageSize.height) animated:animated];
}

- (void)setImage:(UIImage *)image forIndex :(NSUInteger)index
{
    if (index < imageViews.count)
    {
        ((UIImageView *)imageViews[index]).image = image;
        [((UIActivityIndicatorView *)activityIndicators[index]) stopAnimating];
    }
    else
    {
        LogMessage(@"JNImagePagerView warning: tried to set the UIImage for UIImageView %ud that was out of range.", index);
    }
}


#pragma mark Scroll View Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}


#pragma mark - Scroll Completion

- (void)updateCurrentPage
{
    _currentPage = lround(imageScrollView.contentOffset.x / imageScrollView.bounds.size.width);
    if ([_delegate respondsToSelector:@selector(imagePager:landedOnIndex:)])
        [_delegate imagePager:self landedOnIndex:_currentPage];
}

@end
