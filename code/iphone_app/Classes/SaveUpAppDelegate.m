#import "SaveUpAppDelegate.h"

#import "User.h"
#import "AuthenticationViewController.h"
#import "ObjectiveResourceConfig.h"

@interface SaveUpAppDelegate ()
- (void)configureObjectiveResource;
- (void)login;
- (void)showAuthentication:(User *)user;
@end

@implementation SaveUpAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize user;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
    [user removeObserver:self];
    [user release];
	[super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
    
    [self configureObjectiveResource];
    [self login];
}

- (void)configureObjectiveResource {    
#if TARGET_IPHONE_SIMULATOR
    [ObjectiveResourceConfig setSite:@"http://localhost:3000/"];
#else
    [ObjectiveResourceConfig setSite:@"https://saveup.heroku.com/"];
#endif
    [ObjectiveResourceConfig setResponseType:JSONResponse];
    [ObjectiveResourceConfig setUser:[self.user login]];
    [ObjectiveResourceConfig setPassword:[self.user password]];
}

#pragma mark -
#pragma mark Authentication

- (User *)user {
    if (user == nil) {
        NSURL *url = [NSURL URLWithString:[ObjectiveResourceConfig getSite]];
        self.user = [User currentUserForSite:url];
        [user addObserver:self];
    }
    return user;
}

- (void)showAuthentication:(User *)aUser {
    AuthenticationViewController *controller = 
        [[AuthenticationViewController alloc] initWithCurrentUser:aUser];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)login {
    if ([self.user hasCredentials]) {
        NSError *error = nil;
        BOOL authenticated = [self.user authenticate:&error];
        if (authenticated == NO) {
            [AppHelpers handleRemoteError:error];
            [self showAuthentication:self.user];
        }
    } else {
        [self showAuthentication:self.user];
    }
}

#pragma mark -
#pragma mark Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change 
                       context:(void *)context {
    if ([keyPath isEqualToString:kUserLoginKey]) {
        [ObjectiveResourceConfig setUser:[object valueForKeyPath:keyPath]];
    } else if ([keyPath isEqualToString:kUserPasswordKey]){
        [ObjectiveResourceConfig setPassword:[object valueForKeyPath:keyPath]];
    }
}

@end