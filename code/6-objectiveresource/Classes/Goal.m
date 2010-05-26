#import "Goal.h"

@implementation Goal

@synthesize name;
@synthesize amount;
@synthesize goalId;
@synthesize createdAt;
@synthesize updatedAt;

- (void)dealloc {
    [name release];
    [amount release];
    [goalId release];
    [createdAt release];
    [updatedAt release];
	[super dealloc];
}

@end
