#import "Goal.h"

#import "SBJSON.h"
#import "Resource.h"

@implementation Goal

static NSString *siteURL = @"http://localhost:3000";

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

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name      = [dictionary valueForKey:@"name"];
        self.amount    = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"amount"]];
        self.goalId    = [dictionary valueForKey:@"id"];
        self.createdAt = parseDateTime([dictionary valueForKey:@"created_at"]);
        self.updatedAt = parseDateTime([dictionary valueForKey:@"updated_at"]);
    }
    return self;
}

+ (NSArray *)findAllRemote {
    NSString *url = 
        [NSString stringWithFormat:@"%@/goals.json", siteURL];
    
    NSError *error = nil;
    
    NSString *jsonString = [Resource get:url];
    
    NSMutableArray *goals = [NSMutableArray array];
    
    if (jsonString) {
        SBJSON *json = [[SBJSON alloc] init];    
        NSArray *results = [json objectWithString:jsonString error:&error];
        [json release];
        
        for (NSDictionary *dictionary in results) {
            Goal *goal = [[Goal alloc] initWithDictionary:dictionary];
            [goals addObject:goal];
            [goal release];
        }
    }
    
    return goals;    
}

- (NSString *)params {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:self.name forKey:@"name"];
    [attributes setValue:self.amount forKey:@"amount"];
    
    NSMutableDictionary *params = 
        [NSMutableDictionary dictionaryWithObject:attributes forKey:@"goal"];
    
    SBJSON *json = [[[SBJSON alloc] init] autorelease];
    return [json stringWithObject:params error:nil];
}

- (void)createRemote {
    NSString *url = 
        [NSString stringWithFormat:@"%@/goals.json", siteURL];
    [Resource post:[self params] to:url];
}

- (void)updateRemote {
    NSString *url = 
        [NSString stringWithFormat:@"%@/goals/%@.json", siteURL, self.goalId];
    [Resource put:[self params] to:url];
}

- (void)saveRemote {
	if (self.goalId == nil) {
		[self createRemote];
	} else {
		[self updateRemote];
	}
}

- (void)destroyRemote {
    NSString *url = 
        [NSString stringWithFormat:@"%@/goals/%@.json", siteURL, self.goalId];
    [Resource delete:url];
}

@end
