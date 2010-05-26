#import "Session.h"

@implementation Session

@synthesize login;
@synthesize password;

- (void)dealloc {
    [login release];
    [password release];
    [super dealloc];
}

@end
