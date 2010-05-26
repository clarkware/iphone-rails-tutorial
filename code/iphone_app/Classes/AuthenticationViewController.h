@class User;

@interface AuthenticationViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *usernameField;
    UITextField *passwordField;
    User *user;
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) User *user;

- (id)initWithCurrentUser:(User *)user;

- (IBAction)save;

@end
