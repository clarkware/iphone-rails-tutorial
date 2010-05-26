#import <UIKit/UIKit.h>

#import "GoalAddViewController.h"

@class Goal;

@interface GoalDetailViewController : UITableViewController {
    Goal *goal;
    id <GoalChangeDelegate> delegate;
}

@property (nonatomic, retain) Goal *goal;
@property (nonatomic, assign) id <GoalChangeDelegate> delegate;

- (id)initWithGoal:(Goal *)aGoal andDelegate:(id)aDelegate;

- (IBAction)edit;

@end
