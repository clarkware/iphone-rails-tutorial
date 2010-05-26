#import "Credit.h"

@implementation Credit

@synthesize creditId;
@synthesize goalId;

@synthesize name;
@synthesize amount;
@synthesize createdAt;
@synthesize updatedAt;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [creditId release];
    [goalId release];
    [name release];
    [amount release];
    [createdAt release];
    [updatedAt release];
	[super dealloc];
}

- (NSString *)amountAsCurrency {
    return [AppHelpers numberToCurrency:self.amount];
}

#pragma mark ObjectiveResource overrides to handle nested resources

+ (NSString *)getRemoteCollectionName {
	return @"goals";
}

- (NSString *)nestedPath {
	NSString *path = [NSString stringWithFormat:@"%@/credits", goalId];
	if (creditId) {
		path = [path stringByAppendingFormat:@"/%@", creditId];
	}
	return path;
}

- (BOOL)createRemoteWithResponse:(NSError **)aError {
    return [self createRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                       withResponse:aError];
}

- (BOOL)updateRemoteWithResponse:(NSError **)aError {
    return [self updateRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                       withResponse:aError];
}

- (BOOL)destroyRemoteWithResponse:(NSError **)aError {
    return [self destroyRemoteAtPath:[[self class] getRemoteElementPath:[self nestedPath]] 
                        withResponse:aError];
}

@end
