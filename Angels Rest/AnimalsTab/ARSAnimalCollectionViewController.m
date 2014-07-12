//
//  ARSAnimalCollectionViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/13/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSAnimalCollectionViewController.h"
#import "ARSAnimalCell.h"
#import "Animal.h"
#import "ARSAnimalDetailsViewController.h"
#import "FPPopoverController.h"
#import "ARSOptionsTableViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ARSPetfinderCommunicator.h"
#import "JNImageCacher.h"

static NSString * const AnimalCacheName = @"Animals";
static NSString * const AnimalCellIdentifier = @"AnimalCell";
static NSString * const FooterViewIdentifier = @"FooterView";
static NSString * const DetailsSegueIdentifier = @"ShowDetailsSegue";

static CGSize const SortPopoverSize = {200.0f, 288.0f};
static NSString * const AvenirMediumName = @"Avenir-Medium";
static CGFloat FontSize = 16.0f;

@interface ARSAnimalCollectionViewController ()
@end

@implementation ARSAnimalCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.parentContext = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    [self createProgressHUD];
    [self createOptionsPopover];
    [self createRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //refresh whenever we have an empty list
    if (self.fetchedResultsController.fetchedObjects.count == 0)
        [self refreshAnimals:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Setup

- (void)createProgressHUD
{
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.labelFont = [UIFont fontWithName:AvenirMediumName size:FontSize];
    _progressHUD.labelText = @"Loading Animals";
    [self.view addSubview:_progressHUD];
}

- (void)createOptionsPopover
{
    ARSOptionsTableViewController *optionsTableViewController = [[ARSOptionsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    optionsTableViewController.title = @"Filter Options";
    optionsTableViewController.tableView.scrollEnabled = NO;
    optionsTableViewController.delegate = self;
    
    popoverController = [[FPPopoverController alloc] initWithViewController:optionsTableViewController delegate:nil];
    popoverController.tint = FPPopoverDefaultTint;
    popoverController.arrowDirection = FPPopoverArrowDirectionUp;
    popoverController.contentSize = SortPopoverSize;
}

- (void)createRefreshControl
{
    [_refreshControl removeFromSuperview];
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:AvenirMediumName size:FontSize],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh" attributes:attributes];
    _refreshControl.attributedTitle = attributedTitle;
    [_refreshControl addTarget:self action:@selector(refreshAnimals:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:DetailsSegueIdentifier])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        Animal *animal = [_fetchedResultsController objectAtIndexPath:selectedIndexPath];
        ARSAnimalDetailsViewController *detailsViewController = segue.destinationViewController;
        detailsViewController.animal = animal;
    }
}


#pragma mark - Actions

- (void)refreshControlValueChanged:(UIRefreshControl *)control
{
    [self refreshAnimals:NO];
}

- (IBAction)optionsButtonSelected:(id)sender
{
    [popoverController presentPopoverFromPoint:CGPointMake(295, 54)];
}


#pragma mark - Options Table View Controller Delegate

- (void)optionsTableViewController:(ARSOptionsTableViewController *)optionsController selectedSortType:(ARSSortType)sortType
{
    [popoverController dismissPopoverAnimated:YES];
    [self updateFetchRequestWithSortType:sortType];
    [self performFetch];
    [self.collectionView reloadData];
}


#pragma mark - Data Source Refresh

- (void)refreshAnimals:(BOOL)showHUD
{
    if (showHUD == YES)
        [self.progressHUD show:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __weak __typeof(self) weakSelf = self;
    [[ARSPetfinderCommunicator sharedInstance] downloadAllAnimals:^{
        [weakSelf endShowingNetworkActivity];
    } failureBlock:^ {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf endShowingNetworkActivity];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Sorry, an error occurred while communicating with Petfinder."
                                                           delegate:strongSelf
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Retry", nil];
        [alertView show];
    }];
}

- (void)endShowingNetworkActivity
{
    [self.refreshControl endRefreshing];
    [self.progressHUD hide:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self refreshAnimals:YES];
}


#pragma mark Collection View Data Source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARSAnimalCell *animalCell = [collectionView dequeueReusableCellWithReuseIdentifier:AnimalCellIdentifier forIndexPath:indexPath];
    
    Animal *animal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    animalCell.nameLabel.text = [animal.name capitalizedString];;
    animalCell.ageLabel.text = animal.age;
    animalCell.genderLabel.text = animal.genderDisplayText;
    animalCell.backgroundImageView.image = [animal backgroundImageForCell];
    animalCell.photoURL = animal.thumbnailURLString;
    animalCell.photoImageView.image = nil;
    [animalCell.activityIndicator startAnimating];
    
    __weak typeof(animalCell) weakAnimalCell = animalCell;
    [[JNImageCacher sharedInstance] getImage:[animal.imageURLArray firstObject] completionHandler:^(UIImage *image, NSString *urlString) {
        //If the user scrolls quickly through the colleciton view, we don't want to load
        //  images from earlier animals into reused cells now pointing to new animals.
        __strong typeof(weakAnimalCell) strongAnimalCell = weakAnimalCell;
        if ([strongAnimalCell.photoURL isEqualToString:urlString] == YES)
        {
            [strongAnimalCell.activityIndicator stopAnimating];
            strongAnimalCell.photoImageView.image = image;
        }
    }];
    
    return animalCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterViewIdentifier forIndexPath:indexPath];
}


#pragma mark - Core Data Synchronization

- (void)mergeChanges:(NSNotification *)saveNotification
{
    //This managed object context is using NSMainQueueConcurrencyType, so performBlock:
    //  will happen on the main thread, safely updating the collection view.
    [_managedObjectContext performBlock:^{
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
    }];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"Animal" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[nameDescriptor];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:AnimalCacheName];
    _fetchedResultsController.delegate = self;
    
	[self performFetch];
    return _fetchedResultsController;
}

- (void)updateFetchRequestWithSortType:(ARSSortType)sortType
{
    NSString *entityName;
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithCapacity:2];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [sortDescriptors addObject:nameDescriptor]; //every sort type at least sorts Animals by name
    
    //remove old predicate
    fetchRequest.predicate = nil;
    
    switch (sortType) {
        case ARSCatSort:
        {
            entityName = @"Cat";
            break;
        }
        case ARSDogSort:
        {
            entityName = @"Dog";
            break;
        }
        default: //Cats & Dogs, Male, and Female all use the Animal parent entity and also sort by species
        {
            entityName = @"Animal";
            NSSortDescriptor *speciesDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"animalSortPriority" ascending:YES];;
            [sortDescriptors insertObject:speciesDescriptor atIndex:0];
            if (sortType == ARSMaleSort)
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"gender == 'M'"];
            else if (sortType == ARSFemaleSort)
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"gender == 'F'"];
            break;
        }
    }
    fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    [NSFetchedResultsController deleteCacheWithName:AnimalCacheName];
}

- (void)performFetch
{
    NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
	    LogMessage(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Sorry, an error occurred while displaying the animals."
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

@end
