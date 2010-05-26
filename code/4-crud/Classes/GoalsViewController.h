#import "GoalAddViewController.h"

@interface GoalsViewController : UITableViewController <GoalChangeDelegate> {
    NSMutableArray *goals;
}

@property (nonatomic, retain) NSArray *goals;

- (IBAction)add;

@end
