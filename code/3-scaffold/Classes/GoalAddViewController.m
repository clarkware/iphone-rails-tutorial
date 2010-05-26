#import "GoalAddViewController.h"

#import "Goal.h"

@interface GoalAddViewController ()
- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UIBarButtonItem *)newCancelButton;
- (UIBarButtonItem *)newSaveButton;
- (UITextField *)newTextField;
@end

@implementation GoalAddViewController

@synthesize goal;
@synthesize nameField;
@synthesize amountField;
@synthesize delegate;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [goal release];
    [nameField release];
    [amountField release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (id)initWithGoal:(Goal *)aGoal andDelegate:(id)aDelegate {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.goal = aGoal;
        self.delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    nameField = [self newTextField];
    nameField.keyboardType = UIKeyboardTypeASCIICapable;
    [nameField becomeFirstResponder];
    
    amountField = [self newTextField];
    amountField.keyboardType = UIKeyboardTypeNumberPad;

    if (goal.goalId) {
        nameField.text = goal.name;
        amountField.text = goal.amount;
    } else {
        nameField.placeholder = @"Name";
        amountField.placeholder = @"Amount";
    }
    
    UIBarButtonItem *cancelButton = [self newCancelButton];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [self newSaveButton];
    self.navigationItem.rightBarButtonItem = saveButton;
    saveButton.enabled = NO;
    [saveButton release];        
} 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (goal.goalId) {
        self.title = @"Edit Goal";
    } else {
        self.title = @"Add Goal";
    }
}

#pragma mark -
#pragma mark Actions

-(IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save {
    goal.name = nameField.text;
    goal.amount = amountField.text;
    // TODO: create or update remote goal
    [self.delegate didChangeGoal:goal];
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

    [self prepareCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)  {
        [cell.contentView addSubview:nameField];	
    } else { 
        [cell.contentView addSubview:amountField];	
    }
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

- (UIBarButtonItem *)newCancelButton {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Cancel" 
                    style:UIBarButtonSystemItemCancel 
                   target:self 
                   action:@selector(cancel)];
}

- (UIBarButtonItem *)newSaveButton {
    return [[UIBarButtonItem alloc]
            initWithTitle:@"Save" 
                    style:UIBarButtonSystemItemSave
                   target:self 
                   action:@selector(save)];
}

- (UITextField *)newTextField {
    UITextField *textField = 
        [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 285, 25)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self 
                  action:@selector(textFieldChanged:) 
        forControlEvents:UIControlEventEditingChanged];
    return textField;
}  

@end
