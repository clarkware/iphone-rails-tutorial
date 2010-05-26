@class Goal;

@interface GoalAddViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Goal *goal;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;
@property (nonatomic, retain) Goal *goal;

- (id)initWithGoal:(Goal *)goal;

- (IBAction)save;
- (IBAction)cancel;

@end
