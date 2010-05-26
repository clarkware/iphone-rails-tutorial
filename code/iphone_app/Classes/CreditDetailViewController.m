#import "CreditDetailViewController.h"

#import "Credit.h"
#import "ConnectionManager.h"

@interface CreditDetailViewController ()
- (void)saveRemoteCredit;
- (UITextField *)newNameField;
- (UITextField *)newAmountField;
@end

@implementation CreditDetailViewController

@synthesize credit;
@synthesize nameField;
@synthesize amountField;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [nameField release];
    [amountField release];
    [credit release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (id)initWithCredit:(Credit *)aCredit {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.credit = aCredit;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
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
    [saveButton release];        
} 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (credit.creditId) {
        self.title = @"Edit Credit";
        nameField.text = credit.name;
        amountField.text = credit.amount;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.title = @"Add Credit";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Actions

- (IBAction)save {
    credit.name = nameField.text;
    credit.amount = amountField.text;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(saveRemoteCredit) 
                                      onTarget:self];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView 
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
#pragma mark Text Field Delegate methods

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
#pragma mark Private methods

- (void)saveRemoteCredit {
    // If the model is new, then create will be called.
    // Otherwise the model will be updated.
    NSError *error = nil;
    BOOL saved = [credit saveRemoteWithResponse:&error];
    if (saved == YES) {
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
