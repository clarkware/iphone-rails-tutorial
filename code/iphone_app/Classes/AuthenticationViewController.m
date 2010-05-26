#import "AuthenticationViewController.h"

#import "User.h"
#import "ConnectionManager.h"

@interface AuthenticationViewController ()
- (UITextField *)newUsernameField;
- (UITextField *)newPasswordField;
- (void)authenticateRemote;
@end

@implementation AuthenticationViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize user;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [usernameField release];
    [passwordField release];
    [user release];
    [super dealloc];
}

#pragma mark - 
#pragma mark View lifecycle

- (id)initWithCurrentUser:(User *)aUser {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.user = aUser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Login";
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    usernameField = [self newUsernameField];
    [usernameField becomeFirstResponder];

    passwordField = [self newPasswordField];
    
    UIBarButtonItem *saveButton = [AppHelpers newSaveButton:self];
    self.navigationItem.rightBarButtonItem = saveButton;
    saveButton.enabled = NO;
    [saveButton release];
}

#pragma mark - 
#pragma mark Actions

- (IBAction)save {
    user.login = [usernameField text];
    user.password = [passwordField text];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(authenticateRemote) 
                                      onTarget:self];
}

#pragma mark - 
#pragma mark Text Field Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
	if (textField == passwordField) {
        [self save];
    }
	return YES;
}

- (IBAction)textFieldChanged:(id)sender {
    BOOL enableSaveButton = 
        ([self.usernameField.text length] > 0) && ([self.passwordField.text length] > 0);
        [self.navigationItem.rightBarButtonItem setEnabled:enableSaveButton];
}

#pragma mark -
#pragma mark Table data source methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForFooterInSection:(NSInteger)section {
    return @"\nEnter the username and password for your online account.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = 
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                reuseIdentifier:nil] autorelease];
    
    if (indexPath.row == 0)  {
        [cell.contentView addSubview:usernameField];	
    } else { 
        [cell.contentView addSubview:passwordField];	
    }
    
    return cell;
}

#pragma mark -
#pragma mark Private methods

- (void)authenticateRemote {
    NSError *error = nil;
    BOOL authenticated = [user authenticate:&error];
    if (authenticated == YES) {
        [user saveCredentialsToKeychain];
        [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) 
                                                    withObject:[NSNumber numberWithBool:YES] 
                                                 waitUntilDone:NO];  
        [AppHelpers showAlert:@"Welcome!" withMessage:@"Your account information was saved."];
    } else {
        [AppHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (UITextField *)newUsernameField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.placeholder = @"Username";
    field.text = self.user.login;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyNext;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

- (UITextField *)newPasswordField {
    UITextField *field = [AppHelpers newTableCellTextField:self];
    field.placeholder = @"Password";
    field.text = self.user.password;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.secureTextEntry = YES;
    field.returnKeyType = UIReturnKeyDone;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

@end
