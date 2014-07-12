//
//  ARSStatePickerTableViewController.m
//  Angels Rest
//
//  Created by John Newman on 5/10/14.
//  Copyright (c) 2014 John Newman. All rights reserved.
//

#import "ARSStatePickerTableViewController.h"

static NSString * const StateCellIdentifier = @"StateCell";

@interface ARSStatePickerTableViewController ()

@end

@implementation ARSStatePickerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    states = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"States" ofType:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger index = [states indexOfObject:_selectedState];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [states count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StateCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = states[indexPath.row];
    if ([cell.textLabel.text isEqualToString:_selectedState])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(statePickerTableViewController:selectedState:)])
        [_delegate statePickerTableViewController:self selectedState:states[indexPath.row]];
}

@end
