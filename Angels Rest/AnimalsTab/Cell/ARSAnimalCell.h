//
//  ARSAnimalCell.h
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSAnimalCell is used in the collection view in the
//  ARSAnimalCollectionViewController.  The cells display
//  brief animal data and have no iteraction besides the
//  standard tap.
//

#import <UIKit/UIKit.h>
@class Animal;

@interface ARSAnimalCell : UICollectionViewCell

@property (weak, nonatomic, readonly) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic, readonly) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic, readonly) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) NSString *photoURL;

@end
