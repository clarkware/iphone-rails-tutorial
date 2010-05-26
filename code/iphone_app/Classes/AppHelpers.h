#import <Foundation/Foundation.h>

#define TABLE_BACKGROUND_COLOR [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.000]

@interface AppHelpers : NSObject

+ (NSString *)formatDate:(NSDate *)date;
+ (NSDate *)parseDateTime:(NSString *)dateTimeString;

+ (NSString *)numberToCurrency:(NSString *)number;
+ (NSString *)penceToDollars:(NSString *)pence;
+ (NSString *)dollarsToPence:(NSString *)dollars;

+ (UIBarButtonItem *)newCancelButton:(id)target;
+ (UIBarButtonItem *)newSaveButton:(id)target;
+ (UITextField *)newTableCellTextField:(id)delegate;

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message;
+ (void)showAlertWithError:(NSError *)error;
+ (void)handleRemoteError:(NSError *)error;

@end
