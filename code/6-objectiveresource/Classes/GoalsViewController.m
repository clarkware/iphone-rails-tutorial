#import "GoalsViewController.h"

#import "Goal.h"
#import "GoalDetailViewController.h"

@interface GoalsViewController ()
- (UIBarButtonItem *)newAddButton;
@end

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
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [self newAddButton];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];  
    
    [self refresh];
}

#pragma mark -
#pragma mark Actions

- (IBAction)add {
    Goal *goal = [[Goal alloc] init];
    GoalAddViewController *controller = 
        [[GoalAddViewController alloc] initWithGoal:goal andDelegate:self];
    [goal release];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Goal *goal = [goals objectAtIndex:indexPath.row];
    
    cell.textLabel.text = goal.name;
    cell.detailTextLabel.text = numberToCurrency(goal.amount);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates]; 
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        Goal *goal = [goals objectAtIndex:indexPath.row];
        [goal destroyRemote];
        [goals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade]; 
    }
    [tableView endUpdates]; 
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [goals objectAtIndex:indexPath.row];
    GoalDetailViewController *controller = 
        [[GoalDetailViewController alloc] initWithGoal:goal andDelegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Goal lifecycle callbacks

- (void)didChangeGoal:(Goal *)goal {
    [self refresh];
}

#pragma mark -
#pragma mark Private methods

- (UIBarButtonItem *)newAddButton {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  
            target:self 
            action:@selector(add)];    
}

@end

