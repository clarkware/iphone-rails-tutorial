#import "SaveUpAppDelegate.h"

#import "GoalsViewController.h"

@implementation SaveUpAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

@end

