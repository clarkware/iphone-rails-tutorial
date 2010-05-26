#import "ObjectiveResource.h"

@interface Session : NSObject {
    NSString *login;
    NSString *password;
}

@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *password;

@end
