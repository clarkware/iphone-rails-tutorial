#import <Foundation/Foundation.h>

@interface Resource : NSObject {
}

+ (NSString *)get:(NSString *)url;
+ (NSString *)post:(NSString *)body to:(NSString *)url;
+ (NSString *)put:(NSString *)body to:(NSString *)url;
+ (NSString *)delete:(NSString *)url;

@end
