#import "GoalAddViewController.h"

#import "Goal.h"
#import "ConnectionManager.h"

@interface GoalAddViewController ()
- (void)createRemoteGoal;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation GoalAddViewController

@synthesize nameField;
@synthesize amountField;
@synthesize goal;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [goal release];
    [super dealloc];
}

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
    
    self.title = @"Add Goal";
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    nameField = [self newNameField];
    [nameField becomeFirstResponder];

    amountField = [self newAmountField];
    
    UIBarButtonItem *cancelButton = [AppHelpers newCancelButton:self];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [AppHelpers newSaveButton:self];
    self.navigationItem.rightBarButtonItem = saveButton;
    saveButton.enabled = NO;
    [saveButton release];        
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Actions

- (IBAction)save {
    goal.name = nameField.text;
    goal.amount = amountField.text;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(createRemoteGoal) 
                                      onTarget:self];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark Editing

- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
    [textField resignFirstResponder];
	if (textField == nameField) {
        [amountField becomeFirstResponder];
    }
	if (textField == amountField) {
        [self save];
    }
	return YES;
} 

- (IBAction)textFieldChanged:(id)sender {
    BOOL enableSaveButton = 
        ([self.nameField.text length] > 0) && ([self.amountField.text length] > 0);
    [self.navigationItem.rightBarButtonItem setEnabled:enableSaveButton];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = 
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                reuseIdentifier:nil] autorelease];
    
    if (indexPath.row == 0)  {
        [cell.contentView addSubview:nameField];	
    } else { 
        [cell.contentView addSubview:amountField];	
    }
    
    return cell;
} 

#pragma mark -
#pragma mark Private methods

- (void)createRemoteGoal {
    NSError *error = nil;
    BOOL created = [goal createRemoteWithResponse:&error];
    if (created == YES) {
        [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) 
                                                    withObject:[NSNumber numberWithBool:YES] 
                                                 waitUntilDone:NO];     
    } else {
        [AppHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (UITextField *)newNameField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.placeholder = @"Name";
    field.keyboardType = UIKeyboardTypeASCIICapable;
    field.returnKeyType = UIReturnKeyNext;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

- (UITextField *)newAmountField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.placeholder = @"Amount";
    field.keyboardType = UIKeyboardTypeNumberPad;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

@end
