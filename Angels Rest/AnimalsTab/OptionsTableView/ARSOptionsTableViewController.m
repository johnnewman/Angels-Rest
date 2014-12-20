//
//  ARSOptionsTableViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/22/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSOptionsTableViewController.h"

static NSString * const SortCellIdentifier = @"SortCell";

#define CellHeight 44.0f

@interface ARSOptionsTableViewController ()
@end

@implementation ARSOptionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        sortingOptions = @[@"Cats & Dogs", @"Cats", @"Dogs", @"Male", @"Female"];
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0]; //Cats & Dogs is selected first
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortingOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SortCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SortCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0f];
    }
    cell.textLabel.text = [sortingOptions objectAtIndex:indexPath.row];
    
    if ([selectedIndexPath isEqual:indexPath] == YES)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([selectedIndexPath isEqual:indexPath] == NO)
    {
        selectedIndexPath = indexPath;
        [self.tableView reloadData]; //update the cells' accessoryType
        if ([_delegate respondsToSelector:@selector(optionsTableViewController:selectedSortType:)])
        {
            [_delegate optionsTableViewController:self selectedSortType:(int)indexPath.row];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

@end
