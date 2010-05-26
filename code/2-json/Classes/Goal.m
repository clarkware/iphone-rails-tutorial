#import "Goal.h"
#import "SBJSON.h"

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

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name      = [dictionary valueForKey:@"name"];
        self.amount    = [NSString stringWithFormat:@"%@", 
                             [dictionary valueForKey:@"amount"]];
        self.goalId    = [dictionary valueForKey:@"id"];
        self.createdAt = [dictionary valueForKey:@"created_at"];
        self.updatedAt = [dictionary valueForKey:@"updated_at"];
    }
    return self;
}

+ (NSArray *)findAllRemote {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/goals.json"];
    
    NSError *error = nil;
    
    NSString *jsonString = 
        [NSString stringWithContentsOfURL:url 
                                 encoding:NSUTF8StringEncoding 
                                    error:&error];
    
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

@end
