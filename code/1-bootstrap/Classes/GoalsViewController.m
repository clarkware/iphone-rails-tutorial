#import "GoalsViewController.h"

@implementation GoalsViewController

@synthesize goals;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [goals release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Goals";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    NSMutableArray *data = [[NSMutableArray alloc] 
        initWithObjects:@"iPad", @"Tropical Vacation", @"Charitable Donation", nil];
    self.goals = data;
    [data release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [goals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellId = @"GoalCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellId] autorelease];
    }

    NSString *goal = [goals objectAtIndex:indexPath.row];
    cell.textLabel.text = goal;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates]; 
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        [goals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade]; 
    }
    [tableView endUpdates]; 
}

@end
