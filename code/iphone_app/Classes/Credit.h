#import "ObjectiveResource.h"

@interface Credit : NSObject {
    NSString *creditId;
    NSString *goalId;
    NSString *name;
    NSString *amount;
    NSDate   *updatedAt;
    NSDate   *createdAt;
}

@property (nonatomic, copy) NSString *creditId;
@property (nonatomic, copy) NSString *goalId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, retain) NSDate *updatedAt;
@property (nonatomic, retain) NSDate *createdAt;

- (NSString *)amountAsCurrency;

@end
