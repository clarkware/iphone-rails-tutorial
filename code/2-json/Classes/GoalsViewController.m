#import "GoalsViewController.h"

#import "Goal.h"

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

- (IBAction)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.goals = [Goal findAllRemote];
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Goals";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] 
        initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                             target:self 
                             action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [refreshButton release];
 
    [self refresh];
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
    
    static NSString *CellIdentifier = @"GoalCellId";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Goal *goal = [goals objectAtIndex:indexPath.row];
    
    cell.textLabel.text = goal.name;
    cell.detailTextLabel.text = goal.amount;
    
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

