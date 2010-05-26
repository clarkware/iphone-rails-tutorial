@class Credit;

@interface CreditDetailViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Credit      *credit;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;
@property (nonatomic, retain) Credit *credit;

- (id)initWithCredit:(Credit *)credit;

- (IBAction)save;
- (IBAction)cancel;

@end
