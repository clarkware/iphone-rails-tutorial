#import "HTTPRiot.h"

@class Goal;

@protocol GoalChangeDelegate <NSObject>
- (void)didChangeGoal:(Goal *)goal;
@end

@interface GoalAddViewController : UITableViewController <UITextFieldDelegate, HRResponseDelegate> {
    UITextField *nameField;
    UITextField *amountField;
    Goal        *goal;
    id <GoalChangeDelegate> delegate;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *amountField;
@property (nonatomic, retain) Goal *goal;
@property (nonatomic, assign) id <GoalChangeDelegate> delegate;

- (id)initWithGoal:(Goal *)aGoal andDelegate:(id)aDelegate;

- (IBAction)cancel;
- (IBAction)save;

@end
