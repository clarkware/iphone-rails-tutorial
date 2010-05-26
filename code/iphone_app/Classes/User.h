#import <Foundation/Foundation.h>

#define	kUserLoginKey     @"login"
#define kUserPasswordKey  @"password"

@interface User : NSObject {
    NSString *login;
    NSString *password;
    NSURL *siteURL;
}

@property (nonatomic, copy)   NSString *login;
@property (nonatomic, copy)   NSString *password;
@property (nonatomic, retain) NSURL *siteURL;

+ (User *)currentUserForSite:(NSURL *)siteURL;

- (BOOL)hasCredentials;
- (BOOL)authenticate:(NSError **)error;
- (void)saveCredentialsToKeychain;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
