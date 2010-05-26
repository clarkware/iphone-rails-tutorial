@interface Goal : NSObject {
    NSString *name;
    NSString *amount;
    NSString *goalId;
    NSDate *createdAt;
    NSDate *updatedAt;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *goalId;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)findAllRemote;

@end

