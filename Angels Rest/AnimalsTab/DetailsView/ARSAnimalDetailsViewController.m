//
//  ARSAnimalDetailsViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSAnimalDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DDPageControl.h"
#import "Animal.h"
#import "JNImageCacher.h"

@interface ARSAnimalDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet JNImagePagerView *imagePager;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderAndSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *breedLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation ARSAnimalDetailsViewController

@synthesize backgroundImageView = _backgroundImageView,
            mainScrollView = _mainScrollView,
            leftArrowButton = _leftArrowButton,
            rightArrowButton = _rightArrowButton,
            imagePager = _imagePager,
            ageLabel = _ageLabel,
            genderAndSizeLabel = _genderAndSizeLabel,
            breedLabel = _breedLabel,
            descriptionTextView = _descriptionTextView,
            textViewHeightConstraint = _textViewHeightConstraint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [_animal.name capitalizedString];
    
    //No need for arrows if the animal has 0 or 1 image.
    if (_animal.imageURLArray.count <= 1)
    {
        _leftArrowButton.hidden = YES;
        _rightArrowButton.hidden = YES;
    }
    else
    {
        [self disableLeftArrowButton];
        [self createPageControl];
        [self downloadAnimalImages];
    }
    
    _backgroundImageView.image = [_animal backgroundImageForDetailView];
    _imagePager.layer.cornerRadius = 10.0f;
    
    [self setupTextLabels];
    [self expandDescriptionTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Setup

- (void)createPageControl
{
    pageControl = [[DDPageControl alloc] init];
    [pageControl addTarget:self action:@selector(pageControlSelected) forControlEvents:UIControlEventValueChanged];
    pageControl.center = CGPointMake(159, 241);
    pageControl.numberOfPages = [_animal.imageURLArray count];
    pageControl.currentPage = 0;
    pageControl.defersCurrentPageDisplay = NO;
    [pageControl setType:DDPageControlTypeOnFullOffEmpty];
    [pageControl setOnColor:[UIColor darkGrayColor]];
    [pageControl setOffColor:[UIColor darkGrayColor]];
    [pageControl setIndicatorDiameter:10.0f];
    [pageControl setIndicatorSpace:10.0f];
    [_mainScrollView addSubview:pageControl];
}

//Downloads all the animal's images and updates the imagePager as they come in
- (void)downloadAnimalImages
{
    [_animal.imageURLArray enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL *stop) {
        __weak __typeof(self) weakSelf = self;
        [[JNImageCacher sharedInstance] getImage:urlString completionHandler:^(UIImage *image, NSString *urlString) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf != nil)
            {
                NSUInteger imageIndex = [strongSelf.animal.imageURLArray indexOfObject:urlString];
                [strongSelf.imagePager setImage:image forIndex:imageIndex];
            }
        }];
    }];
}

- (void)setupTextLabels
{
    _ageLabel.text = _animal.age;
    _genderAndSizeLabel.text = [NSString stringWithFormat:@"%@ %@", _animal.sizeDisplayText, _animal.genderDisplayText];
    _breedLabel.text = _animal.breed;
    _descriptionTextView.text = _animal.desc;
}

//Expands the height constraint of the text view, which will automatically
//  increase the contentSize of the scroll view since its contained elements'
//  combined height components define the contentSize height.
//More info: https://developer.apple.com/library/ios/technotes/tn2154/_index.html
- (void)expandDescriptionTextView
{
    CGFloat sideEdgeInsetTotal = 16.0f;
    CGFloat topAndBottomEdgeInsetTotal = 16.0f;
    NSDictionary *textAttributes = @{NSFontAttributeName : _descriptionTextView.font};
    CGSize maxDescriptionSize = CGSizeMake(_descriptionTextView.frame.size.width - sideEdgeInsetTotal, CGFLOAT_MAX);
    CGRect descriptionRect = [_descriptionTextView.text boundingRectWithSize:maxDescriptionSize
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                  attributes:textAttributes
                                                                     context:nil];
    _textViewHeightConstraint.constant = descriptionRect.size.height + topAndBottomEdgeInsetTotal;
}


#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    offset.x = 0.0f;
    scrollView.contentOffset = offset;
}


#pragma mark - Arrow Buttons

- (void)enableLeftArrowButton
{
    _leftArrowButton.userInteractionEnabled = YES;
    _leftArrowButton.alpha = 1.0f;
}

- (void)disableLeftArrowButton
{
    _leftArrowButton.userInteractionEnabled = NO;
    _leftArrowButton.alpha = 0.5f;
}

- (void)enableRightArrowButton
{
    _rightArrowButton.userInteractionEnabled = YES;
    _rightArrowButton.alpha = 1.0f;
}

- (void)disableRightArrowButton
{
    _rightArrowButton.userInteractionEnabled = NO;
    _rightArrowButton.alpha = 0.5f;
}

- (IBAction)leftArrowSelected:(id)sender
{
    NSUInteger pageToScroll = _imagePager.currentPage - 1;
    [_imagePager scrollToPage:pageToScroll animated:YES];
    [pageControl setCurrentPage:pageToScroll];
    if (pageToScroll == 0) //at beginning of images
        [self disableLeftArrowButton];
    [self enableRightArrowButton];
}

- (IBAction)rightArrowSelected:(id)sender
{
    NSUInteger pageToScroll = _imagePager.currentPage + 1;
    [_imagePager scrollToPage:pageToScroll animated:YES];
    [pageControl setCurrentPage:pageToScroll];
    if (pageToScroll == _animal.imageURLArray.count - 1) //at end of images
        [self disableRightArrowButton];
    [self enableLeftArrowButton];
}


#pragma mark - DDPageControl Callback

- (void)pageControlSelected
{
    [_imagePager scrollToPage:pageControl.currentPage animated:YES];
}


#pragma mark - JNImagePagerViewDataSource

- (NSUInteger)numberOfImagesInImagePagerView:(JNImagePagerView *)imagePagerView
{
    return [_animal.imageURLArray count];
}

- (UIViewContentMode)imagePagerView:(JNImagePagerView *)imagePagerView contentModeForImageIndex:(NSInteger)index
{
    return UIViewContentModeScaleAspectFit;
}


#pragma mark - JNImagePagerViewDelegate

- (void)imagePager:(JNImagePagerView *)imagePager landedOnIndex:(NSUInteger)index
{
    [pageControl setCurrentPage:index];
    if (index == 0)
    {
        [self disableLeftArrowButton];
        [self enableRightArrowButton];
    }
    else if (index == _animal.imageURLArray.count - 1)
    {
        [self disableRightArrowButton];
        [self enableLeftArrowButton];
    }
    else
    {
        [self enableLeftArrowButton];
        [self enableRightArrowButton];
    }
}

@end
