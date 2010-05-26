#import "Goal.h"

#import "Credit.h"

@implementation Goal

@synthesize goalId;
@synthesize name;
@synthesize amount;
@synthesize updatedAt;
@synthesize createdAt;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [goalId release];
    [name release];
    [amount release];
    [updatedAt release];
    [createdAt release];
	[super dealloc];
}

- (NSArray *)findAllRemoteCredits {
	return [Credit findRemote:[NSString stringWithFormat:@"%@/%@", 
                                goalId, @"credits"]];
}

- (NSString *)amountAsCurrency {
    return [AppHelpers numberToCurrency:self.amount];
}

@end

