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
        self.amount    = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"amount"]];
        self.goalId    = [dictionary valueForKey:@"id"];
        self.createdAt = parseDateTime([dictionary valueForKey:@"created_at"]);
        self.updatedAt = parseDateTime([dictionary valueForKey:@"updated_at"]);
    }
    return self;
}

+ (NSArray *)makeGoalsFromJSONArray:(NSArray *)results  {
    NSMutableArray *goals = [NSMutableArray array];
    
    for (NSDictionary *dictionary in results) {
        Goal *goal = [[Goal alloc] initWithDictionary:dictionary];
        [goals addObject:goal];
        [goal release];
    }
    
    return goals;    
}

- (NSString *)JSONRepresentation {    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:self.name forKey:@"name"];
    [attributes setValue:self.amount forKey:@"amount"];
    
    NSMutableDictionary *params = 
        [NSMutableDictionary dictionaryWithObject:attributes forKey:@"goal"];
    
    return [params JSONRepresentation];
}

@end
