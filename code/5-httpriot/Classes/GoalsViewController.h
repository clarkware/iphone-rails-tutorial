#import "GoalAddViewController.h"

#import "HTTPRiot.h"

@interface GoalsViewController : UITableViewController <GoalChangeDelegate, HRResponseDelegate> {
    NSMutableArray *goals;
    NSIndexPath    *indexPathOfItemToDelete;
    BOOL           isDeleting;
}

@property (nonatomic, retain) NSMutableArray *goals;

- (IBAction)add;

@end
