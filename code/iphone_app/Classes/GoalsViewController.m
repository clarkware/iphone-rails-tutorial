#import "GoalsViewController.h"

#import "Goal.h"
#import "ConnectionManager.h"
#import "GoalAddViewController.h"
#import "GoalDetailViewController.h"

@interface GoalsViewController ()
- (void)fetchRemoteGoals;
- (UIBarButtonItem *)newAddButton;
- (void)showGoal:(Goal *)goal;
- (void)deleteRowsAtIndexPaths:(NSArray *)array;
- (void)destroyRemoteGoalAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation GoalsViewController

@synthesize goals;
@synthesize tableView;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [goals release];
    [tableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)add {
    Goal *goal = [[Goal alloc] init];
    GoalAddViewController *controller = 
        [[GoalAddViewController alloc] initWithGoal:goal];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [goal release];
}

- (IBAction)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ConnectionManager sharedInstance] runJob:@selector(fetchRemoteGoals) 
                                      onTarget:self];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Goals";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [self newAddButton];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];    
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark -
#pragma mark Table data source methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [goals count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *GoalCellId = @"GoalCellId";
    
    UITableViewCell *cell = 
        [aTableView dequeueReusableCellWithIdentifier:GoalCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:GoalCellId] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Goal *goal = [goals objectAtIndex:indexPath.row];
    
    cell.textLabel.text = goal.name;
    cell.detailTextLabel.text = [goal amountAsCurrency];
    
    return cell;
}

-  (void)tableView:(UITableView *)aTableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView beginUpdates]; 
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ConnectionManager sharedInstance] runJob:@selector(destroyRemoteGoalAtIndexPath:) 
                                          onTarget:self
                                      withArgument:indexPath];
    }
    [aTableView endUpdates]; 
} 

- (void)destroyRemoteGoalAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [goals objectAtIndex:indexPath.row];
    NSError *error = nil;
    BOOL destroyed = [goal destroyRemoteWithResponse:&error];
    if (destroyed == YES) {
        [goals removeObjectAtIndex:indexPath.row];
        [self performSelectorOnMainThread:@selector(deleteRowsAtIndexPaths:) 
                               withObject:[NSArray arrayWithObject:indexPath]  
                            waitUntilDone:NO];
    } else {    
        [AppHelpers handleRemoteError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)deleteRowsAtIndexPaths:(NSArray *)array {
    [tableView deleteRowsAtIndexPaths:array
                     withRowAnimation:UITableViewRowAnimationFade]; 
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [goals objectAtIndex:indexPath.row];
    [self showGoal:goal];
}

#pragma mark -
#pragma mark Private methods

- (void)fetchRemoteGoals {
    NSError *error = nil;
    self.goals = [Goal findAllRemoteWithResponse:&error];
    if (self.goals == nil && error != nil) {
        [AppHelpers handleRemoteError:error];
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showGoal:(Goal *)goal {
	GoalDetailViewController *controller = 
        [[GoalDetailViewController alloc] initWithGoal:goal];
	[self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (UIBarButtonItem *)newAddButton {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                 target:self 
                                 action:@selector(add)];
}

@end
