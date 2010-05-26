#import "GoalDetailViewController.h"

#import "Goal.h"
#import "Credit.h"
#import "ConnectionManager.h"
#import "CreditDetailViewController.h"

@interface GoalDetailViewController ()
- (void)fetchRemoteCredits;
- (void)updateRemoteGoal;
- (void)deleteRowsAtIndexPaths:(NSArray *)array;
- (void)destroyRemoteCreditAtIndexPath:(NSIndexPath *)indexPath;
- (void)showCredit:(Credit *)credit;
- (UITableViewCell *)makeCreditCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITableViewCell *)makeAddCreditCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITableViewCell *)makeGoalCell:(UITableView *)tableView forRow:(NSUInteger)row;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation GoalDetailViewController

@synthesize nameField;
@synthesize amountField;
@synthesize goal;
@synthesize credits;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [goal release];
    [credits release];
    [super dealloc];
}

enum GoalDetailTableSections {
	kGoalSection = 0,
    kCreditsSection
};

#pragma mark -
#pragma mark View lifecycle

- (id)initWithGoal:(Goal *)aGoal {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.goal = aGoal;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = goal.name;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    nameField = [self newNameField];
    amountField = [self newAmountField];
    
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(fetchRemoteCredits) 
                                      onTarget:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.navigationItem setHidesBackButton:editing animated:YES];

	nameField.enabled = editing;
	amountField.enabled = editing;
    
	[self.tableView beginUpdates];
	
    NSUInteger creditsCount = [credits count];
    
    NSArray *creditsInsertIndexPath = 
        [NSArray arrayWithObject:[NSIndexPath indexPathForRow:creditsCount 
                                                    inSection:kCreditsSection]];
    
    if (editing) {
        amountField.text = goal.amount;           

        [self.tableView insertRowsAtIndexPaths:creditsInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
	} else {
        amountField.text = [goal amountAsCurrency];         

        [self.tableView deleteRowsAtIndexPaths:creditsInsertIndexPath 
                              withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(updateRemoteGoal) 
                                      onTarget:self];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField == nameField) {
		goal.name = nameField.text;
		self.title = goal.name;
	} else if (textField == amountField) {
        goal.amount = amountField.text;
	}
	return YES;
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case kGoalSection:
            rows = 2;
            break;
        case kCreditsSection:
            rows = [credits count];
            if (self.editing) {
                rows++; // "Add Credit" cell
            }
            break;
        default:
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case kGoalSection:
			title = @"Goal";
            break;
        case kCreditsSection:
			title = @"Credits";
            break;
	}
  	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = nil;

    NSUInteger row = indexPath.row;

    // For the Credits section, create a cell for each credit.
    if (indexPath.section == kCreditsSection) {
		NSUInteger creditsCount = [credits count];
        if (row < creditsCount) {
            cell = [self makeCreditCell:tableView forRow:row];
        } 
        // If the row is outside the range of the credits, it's
        // the row that was added to allow insertion.
        else {
            cell = [self makeAddCreditCell:tableView forRow:row];
        }
    }
    // For the Goal section, create a cell for each text field.
    else {
        cell = [self makeGoalCell:tableView forRow:row];
    }
    
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing && (indexPath.section == kCreditsSection)) {
        return indexPath;
    }
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kCreditsSection) {
        Credit *credit = nil;
        if (indexPath.row < [credits count]) {
            credit = [credits objectAtIndex:indexPath.row];
        } else {
            credit = [[[Credit alloc] init] autorelease];
            credit.goalId = goal.goalId;
        }
        [self showCredit:credit];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the Credits section.  The last row
    // was added automatically for adding a new credit.  All
    // other rows are eligible for deletion.
    if (indexPath.section == kCreditsSection) {
        if (indexPath.row == [credits count]) {
            style = UITableViewCellEditingStyleInsert;
        } else {
            style = UITableViewCellEditingStyleDelete;
        }
    }    
    return style;
}

 - (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow deletion in the Credits section.
    if ((editingStyle == UITableViewCellEditingStyleDelete) && 
        (indexPath.section == kCreditsSection)) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ConnectionManager sharedInstance] runJob:@selector(destroyRemoteCreditAtIndexPath:) 
                                          onTarget:self
                                      withArgument:indexPath];
    }
}

- (void)destroyRemoteCreditAtIndexPath:(NSIndexPath *)indexPath {
    Credit *credit = [credits objectAtIndex:indexPath.row];
    NSError *error = nil;
    BOOL destroyed = [credit destroyRemoteWithResponse:&error];
    if (destroyed == YES) {
        [credits removeObjectAtIndex:indexPath.row];
        [self performSelectorOnMainThread:@selector(deleteRowsAtIndexPaths:) 
                               withObject:[NSArray arrayWithObject:indexPath]  
                            waitUntilDone:NO];
    } else {    
        [AppHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)array {
    [self.tableView deleteRowsAtIndexPaths:array
                          withRowAnimation:UITableViewRowAnimationTop]; 
}

#pragma mark -
#pragma mark Private methods

- (void)fetchRemoteCredits {
    self.credits = [NSMutableArray arrayWithArray:[goal findAllRemoteCredits]];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)updateRemoteGoal {
    NSError *error = nil;
    BOOL updated = [goal updateRemoteWithResponse:&error];
    if (updated == NO) {
        [AppHelpers handleRemoteError:error];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showCredit:(Credit *)credit {
    CreditDetailViewController *controller = 
        [[CreditDetailViewController alloc] initWithCredit:credit];
    [self.navigationController pushViewController:controller animated:YES];	
    [controller release];
}

- (UITableViewCell *)makeCreditCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *CreditCellId = @"CreditCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CreditCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:CreditCellId] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Credit *credit = [credits objectAtIndex:row];

    cell.textLabel.text = credit.name;
    cell.detailTextLabel.text = [credit amountAsCurrency];
    
    return cell;
}

- (UITableViewCell *)makeAddCreditCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *AddCreditCellId = @"AddCreditCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:AddCreditCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:AddCreditCellId] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"Add Credit";   
    
    return cell;
}

- (UITableViewCell *)makeGoalCell:(UITableView *)tableView forRow:(NSUInteger)row {
    static NSString *GoalCellId = @"GoalCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:GoalCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:GoalCellId] autorelease];
    }
    
    if (row == 0)  {
        [cell.contentView addSubview:nameField];	
    } else { 
        [cell.contentView addSubview:amountField];	
    }
    
    return cell;
}

- (UITextField *)newNameField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.text = goal.name;
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.enabled = NO;
    return field;
}

- (UITextField *)newAmountField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.text = [goal amountAsCurrency]; 
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.enabled = NO;
    return field;
}

@end
