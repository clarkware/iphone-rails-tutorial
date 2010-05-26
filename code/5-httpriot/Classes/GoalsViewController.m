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
    indexPathOfItemToDelete = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (IBAction)refresh {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [HRRestModel setDelegate:self];
    [HRRestModel getPath:@"/goals" withOptions:nil object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Goals";
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [self newAddButton];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];  
    
    isDeleting = NO;
    
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
    
    static NSString *CellIdentifier = @"GoalCellId";
    
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
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        isDeleting = YES;
        indexPathOfItemToDelete = indexPath;
        Goal *goal = [goals objectAtIndex:indexPath.row];
        [HRRestModel deletePath:[NSString stringWithFormat:@"goals/%@", goal.goalId]
                                withOptions:nil object:nil];
    }
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
#pragma mark HRRestConnection delegate methods

- (void)restConnection:(NSURLConnection *)connection 
     didReturnResource:(id)resource 
                object:(id)object { 
    if (isDeleting) {
        [goals removeObjectAtIndex:indexPathOfItemToDelete.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathOfItemToDelete, nil] 
                         withRowAnimation:UITableViewRowAnimationFade];         
        [self.tableView endUpdates];
        isDeleting = NO;
    } else {
        NSMutableArray *remoteGoals = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in resource) {
            Goal *remoteGoal = [[Goal alloc] initWithDictionary:dictionary];
            [remoteGoals addObject:remoteGoal];
            [remoteGoal release];
        }
        self.goals = remoteGoals;
        [remoteGoals release];

        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)restConnection:(NSURLConnection *)connection 
    didReceiveResponse:(NSHTTPURLResponse *)response 
                object:(id)object {
    //NSLog(@"Response status code: %i", [response statusCode]);
}

- (void)restConnection:(NSURLConnection *)connection 
      didFailWithError:(NSError *)error 
                object:(id)object {
    showAlert([error localizedDescription]);
}

- (void)restConnection:(NSURLConnection *)connection 
       didReceiveError:(NSError *)error 
              response:(NSHTTPURLResponse *)response 
                object:(id)object {
    showAlert([error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
  didReceiveParseError:(NSError *)error 
          responseBody:(NSString *)string {
    showAlert([error localizedDescription]);
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

