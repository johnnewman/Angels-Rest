//
//  ARSAnimalCollectionViewController.h
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//
//  ARSAnimalCollectionViewController displays a collection of all
//  the sacntuary's cats and dogs.  These are retrieved from the
//  Petfinder API using the ARSPetfinderCommunicator.  Animals are
//  stored in Core Data.  Users can filter the collection vai the
//  ARSOptionsTableViewController to display cats & dogs, only cats,
//  only dogs, only male, and only female.  Selecting an animal
//  will display the animal's details in the ARSAnimalDetailsViewController.
//

#import <UIKit/UIKit.h>
#import "ARSOptionsTableViewControllerDelegate.h"
#import <WYPopoverController.h>

@class MBProgressHUD;

@interface ARSAnimalCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, ARSOptionsTableViewControllerDelegate, UIAlertViewDelegate, WYPopoverControllerDelegate>
{
    WYPopoverController *popoverController;
    NSFetchRequest *fetchRequest;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@end
