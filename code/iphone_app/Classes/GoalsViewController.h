@interface GoalsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *goals;
    UITableView *tableView;
}

@property (nonatomic, retain) NSArray *goals;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)add;
- (IBAction)refresh;

@end
