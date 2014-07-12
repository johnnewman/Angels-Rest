//
//  ARSAnimalCell.m
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSAnimalCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ARSAnimalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@end

@implementation ARSAnimalCell

@synthesize backgroundImageView = _backgroundImageView,
            photoImageView = _photoImageView,
            activityIndicator = _activityIndicator,
            nameLabel = _nameLabel,
            ageLabel = _ageLabel,
            genderLabel = _genderLabel;

@end
