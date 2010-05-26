#import "GoalDetailViewController.h"

#import "Goal.h"

@interface GoalDetailViewController ()
- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (UIBarButtonItem *)newEditButton;
@end

@implementation GoalDetailViewController

@synthesize goal;
@synthesize delegate;

enum ExpenseTableSections {
    kNameSection = 0,
    kAmountSection,
    kDateSection
};

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [goal release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (id)initWithGoal:(Goal *)aGoal andDelegate:(id)aDelegate {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.goal = aGoal;
        self.delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = TABLE_BACKGROUND_COLOR;

    UIBarButtonItem *editButton = [self newEditButton];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = goal.name;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Actions

- (IBAction)edit {
    GoalAddViewController *controller = 
      [[GoalAddViewController alloc] initWithGoal:goal andDelegate:self.delegate];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
		case kNameSection:
			title = @"Name";
            break;
		case kAmountSection:
			title = @"Amount";
            break;
        case kDateSection:
			title = @"Date";
            break;
	}
  	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"GoalCellId";
	
	UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}

    [self prepareCell:cell forIndexPath:indexPath];

	return cell;
}

- (void)prepareCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
		case kNameSection:
			cell.textLabel.text = goal.name;
			break;
		case kAmountSection:
            cell.textLabel.text = numberToCurrency(goal.amount);
            break;
        case kDateSection:
            cell.textLabel.text = formatDate(goal.createdAt);
            break;
	}
}

#pragma mark -
#pragma mark Private methods

- (UIBarButtonItem *)newEditButton {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                 target:self 
                                 action:@selector(edit)];
}

@end
