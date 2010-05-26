@class Goal;

@interface GoalDetailViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Goal *goal;
    NSMutableArray *credits;
}

@property (nonatomic, retain) Goal *goal;
@property (nonatomic, retain) NSMutableArray *credits;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;

- (id)initWithGoal:(Goal *)goal;

@end
