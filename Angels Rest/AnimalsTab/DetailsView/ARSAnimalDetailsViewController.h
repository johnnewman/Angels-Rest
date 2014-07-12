//
//  ARSAnimalDetailsViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSAnimalDetailsViewController displays more detailed animal
//  information than what is in the ARSAnimalCells.  When loaded,
//  it calculates the height it will need to render all of its
//  content, then it updates auto layout constraints to increase
//  the content size of the scroll view.  This needs to happen
//  because each animal has a different amount of description text.
//
//  The animals' photos are displayed in a JNImagePagerView at the
//  top.  To navigate photos, the user can swipe the pager, tap the
//  arrow buttons, or select the DPageControl below the image pager.
//

#import <UIKit/UIKit.h>
#import "JNImagePagerView.h"
@class DDPageControl;
@class Animal;

@interface ARSAnimalDetailsViewController : UIViewController <JNImagePagerViewDataSource, JNImagePagerViewDelegate, UIScrollViewDelegate>
{
    DDPageControl *pageControl;
}

@property (weak, nonatomic) Animal *animal;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic, readonly) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic, readonly) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic, readonly) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic, readonly) IBOutlet JNImagePagerView *imagePager;

@property (weak, nonatomic, readonly) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *genderAndSizeLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *breedLabel;
@property (weak, nonatomic, readonly) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic, readonly) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end
