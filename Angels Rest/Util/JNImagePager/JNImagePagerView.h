//
//  JNImagePagerView.h
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  JNImagePager is a view used to display a paginated scroll view
//  of images.  The caller simply needs to implement the data source
//  to provide the image count and then assign the images using
//  setImage:forIndex:.  Various contentModes for displaying the images
//  can be assigned using the optional contentModeForImageIndex: data
//  source method.
//
//  The delegate and data source are define here as opposed to a spearate
//  header to cut down on dependencies when importing into other projects.
//

#import <UIKit/UIKit.h>

@protocol JNImagePagerViewDataSource;
@protocol JNImagePagerViewDelegate;

@interface JNImagePagerView : UIView <UIScrollViewDelegate>
{
    UIScrollView *imageScrollView;
    NSMutableArray *imageViews;
    NSMutableArray *activityIndicators;
}
@property (weak, nonatomic) IBOutlet id<JNImagePagerViewDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id<JNImagePagerViewDelegate> delegate;
@property (assign, nonatomic, readonly) NSUInteger currentPage;

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;
- (void)setImage:(UIImage *)image forIndex:(NSUInteger)index;
@end



@protocol JNImagePagerViewDataSource <NSObject>
@required
- (NSUInteger)numberOfImagesInImagePagerView:(JNImagePagerView *)imagePagerView;
@optional
- (UIViewContentMode)imagePagerView:(JNImagePagerView *)imagePagerView contentModeForImageIndex:(NSInteger)index;
@end



@protocol JNImagePagerViewDelegate <NSObject>
@optional
- (void)imagePager:(JNImagePagerView *)imagePager landedOnIndex:(NSUInteger)index;
@end
