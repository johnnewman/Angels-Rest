//
//  ARSConstantContactTableViewController.m
//  Angels Rest
//
//  Created by John Newman on 7/20/13.
//  Copyright (c) 2013 John Newman. All rights reserved.
//

#import "ARSConstantContactTableViewController.h"
#import "ARSConstantContactCell.h"
#import "ARSStatePickerTableViewController.h"
#import "ARSConstantContactCommunicator.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const StatePickerSegueIdentifier = @"StatePickerSegue";
static NSString * const ConstantContactTermsURL = @"http://www.constantcontact.com/uidocs/CCSiteOwnerAgreement.jsp";
static NSString * const EmailRegex = @"^.+@{1}.+\\.{1}.+$";

static CGFloat const HeaderHeight = 22.0f;
static CGRect const HeaderViewFrame = {0, 0, 320, HeaderHeight};
static CGRect const HeaderLabelFrame = {20, 0, 280, HeaderHeight};

//Constant Contact keys
static NSString * const FirstNameKey = @"first_name";
static NSString * const LastNameKey = @"last_name";
static NSString * const EmailKey = @"email";
static NSString * const CellPhoneKey = @"cell_phone";
static NSString * const Line1Key = @"line1";
static NSString * const Line2Key = @"line2";
static NSString * const CityKey = @"city";
static NSString * const StateAbbKey = @"state_code";
static NSString * const ZipKey = @"postal_code";
static NSString * const AddressInfoKey = @"address_info";

@interface ARSConstantContactTableViewController ()
@end

@implementation ARSConstantContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createProgressHUD];
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
    _progressHUD.labelFont = [UIFont fontWithName:@"Avenir-Medium" size:16.0f];
    _progressHUD.labelText = @"Submitting";
    [self.view addSubview:_progressHUD];
}


#pragma mark Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:HeaderViewFrame];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:HeaderLabelFrame];
    headerLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section];
    [headerView addSubview:headerLabel];
    return headerView;
}


#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARSConstantContactCell *contactCell = (ARSConstantContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (contactCell == _stateCell)
        [self performSegueWithIdentifier:StatePickerSegueIdentifier sender:self];
    else
        [contactCell.textField becomeFirstResponder];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:StatePickerSegueIdentifier])
    {
        ARSStatePickerTableViewController *statePickerTableViewController = segue.destinationViewController;
        statePickerTableViewController.selectedState = _stateCell.textField.text;
        statePickerTableViewController.delegate = self;
    }
}


#pragma mark State Picker Delegate

- (void)statePickerTableViewController:(ARSStatePickerTableViewController *)controller selectedState:(NSString *)state
{
    [self.navigationController popViewControllerAnimated:YES];
    _stateCell.textField.text = state;
}


#pragma mark Constant Contact Cell Delegate

- (void)constantContactCellDidBeginEnteringText:(ARSConstantContactCell *)contactCell
{
    cellBeingEdited = contactCell;
}

- (void)constantContactCellTextFieldIsReturning:(ARSConstantContactCell *)contactCell
{
    cellBeingEdited = nil;
    
    //Find the next text field to select
    if (contactCell == _firstNameCell)
        cellBeingEdited = _lastNameCell;
    else if (contactCell == _lastNameCell)
        cellBeingEdited = _emailCell;
    else if (contactCell == _emailCell)
        cellBeingEdited = _cellPhoneCell;
    //The cell phone field has no return button
    else if (contactCell == _addressLine1Cell)
        cellBeingEdited = _addressLine2Cell;
    else if (contactCell == _addressLine2Cell)
        cellBeingEdited = _cityCell;
    //The state cell needs to be manually selected
    else if (contactCell == _cityCell)
        cellBeingEdited = _zipCell;
    //The zip cell has no return button
    
    [[cellBeingEdited textField] becomeFirstResponder];
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cellBeingEdited];
    [self.tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark Actions

- (IBAction)termsAndConditionsSelected:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ConstantContactTermsURL]];
}

- (IBAction)submitSelected:(id)sender
{
    //Dismiss the keyboard
    [cellBeingEdited.textField resignFirstResponder];
    [self prepareToSendData];
}


#pragma mark - Data Validation

- (BOOL)cellFieldHasText:(ARSConstantContactCell *)contactCell animateFailures:(BOOL)animate
{
    if (contactCell.textField.text.length == 0)
    {
        if (animate == YES)
            [self animateTextErrorForCell:contactCell];
        return NO;
    }
    else
    {
        return YES;
    }
}

//Animates a red background glow an a cell
- (void)animateTextErrorForCell:(ARSConstantContactCell *)contactCell
{
    contactCell.contentView.layer.backgroundColor = [UIColor colorWithRed:1 green:86/255.0 blue:104/255.0 alpha:1].CGColor;
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        [contactCell.contentView.layer setBackgroundColor:[UIColor clearColor].CGColor];
    } completion:nil];
}

//Compares the cell's text field text against the regex pattern
- (BOOL)validateCellText:(ARSConstantContactCell *)contactCell withRegex:(NSString *)pattern
{
    NSString *text = contactCell.textField.text;
    NSError *regexError;
    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:&regexError];
    NSInteger numberOfMatches = [emailRegex numberOfMatchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];
    return numberOfMatches > 0;
}

//Validates that all the required data exists and packages the data into a
//  dictionary for sending.
- (void)prepareToSendData
{
    BOOL hasRequiredFields = [self cellFieldHasText:_firstNameCell animateFailures:YES] &&
                             [self cellFieldHasText:_lastNameCell animateFailures:YES] &&
                             [self cellFieldHasText:_emailCell animateFailures:YES];
    if (hasRequiredFields == YES)
    {
       if ([self validateCellText:_emailCell withRegex:EmailRegex] == YES)
       {
           NSMutableDictionary *contactDict = [NSMutableDictionary dictionaryWithCapacity:3];
           contactDict[FirstNameKey] = _firstNameCell.textField.text;
           contactDict[LastNameKey] = _lastNameCell.textField.text;
           contactDict[EmailKey] = _emailCell.textField.text;
           
           //Cell phone is optional
           if ([self cellFieldHasText:_cellPhoneCell animateFailures:NO] == YES)
               contactDict[CellPhoneKey] = _cellPhoneCell.textField.text;
           
           //Construct the optional address dictionary
           NSMutableDictionary *addressDict = [NSMutableDictionary dictionaryWithCapacity:5];
           if ([self cellFieldHasText:_addressLine1Cell animateFailures:NO])
           {
               addressDict[Line1Key] = _addressLine1Cell.textField.text;
               if ([self cellFieldHasText:_addressLine2Cell animateFailures:NO])
                   addressDict[Line2Key] = _addressLine2Cell.textField.text;
           }
           if ([self cellFieldHasText:_cityCell animateFailures:NO])
               addressDict[CityKey] = _cityCell.textField.text;
           if ([self cellFieldHasText:_stateCell animateFailures:NO])
               addressDict[StateAbbKey] = _stateCell.textField.text;
           if ([self cellFieldHasText:_zipCell animateFailures:NO])
               addressDict[ZipKey] = _zipCell.textField.text;
           
           //The optional address fields could have all been left blank
           if (addressDict.count > 0)
               contactDict[AddressInfoKey] = addressDict;

           [self sendContactDictionary:contactDict];
        }
        else //A proper email is vital
        {
            UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"The email provided is not in a valid format."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
            [emailAlert show];
        }
    }
}


#pragma mark - Network Communication

- (void)sendContactDictionary:(NSDictionary *)contactDict
{
    [_progressHUD show:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __weak __typeof(self) weakSelf = self;
    [[ARSConstantContactCommunicator sharedInstance] addContact:contactDict successBlock:^{
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.progressHUD.mode = MBProgressHUDModeText;
        strongSelf.progressHUD.labelText = @"You've been subscribed!";
        [strongSelf.progressHUD hide:NO afterDelay:1.5f];
        [strongSelf performSelector:@selector(executeDismissSegue) withObject:nil afterDelay:1.5f];
    } failureBlock:^(ARSCCFailureCode failureCode) {
        
        [weakSelf.progressHUD hide:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *message;
        if (failureCode == ARSCCAlreadyExists)
            message = @"The provided email is already in the mailing list.";
        else
            message = @"Sorry, an error occured while trying to add you to the mailing list.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:message
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)executeDismissSegue
{
    [self performSegueWithIdentifier:@"DismissConstantContactSegue" sender:self];   
}

@end
