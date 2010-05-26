#import "AppHelpers.h"

@implementation AppHelpers

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *result = [formatter stringFromDate:date];
    [formatter release];
    return result;
}

+ (NSDate *)parseDateTime:(NSString *)dateTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *result = [formatter dateFromString:dateTimeString];
    [formatter release];
    return result;
}

+ (NSString *)numberToCurrency:(NSString *)number {
    if (number == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *decimalNumber = 
    [NSDecimalNumber decimalNumberWithString:number];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMinimumFractionDigits:2];
    
    NSString *result = [formatter stringFromNumber:decimalNumber];
    
    [formatter release];
    return result;
}

+ (NSString *)penceToDollars:(NSString *)pence {
    if (pence == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *penceNumber =
        [NSDecimalNumber decimalNumberWithString:pence];
    
    NSDecimalNumber *dollars = 
        [penceNumber decimalNumberByDividingBy:
            [NSDecimalNumber decimalNumberWithString:@"100"]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:2];
    
    NSString *result = [formatter stringFromNumber:dollars];
    
    [formatter release];
    return result;
}

+ (NSString *)dollarsToPence:(NSString *)dollars {
    if (dollars == nil) {
        return @"$0.00";
    }
    
    NSDecimalNumber *dollarsNumber =
        [NSDecimalNumber decimalNumberWithString:dollars];
    
    NSDecimalNumber *pence = 
        [dollarsNumber decimalNumberByMultiplyingBy:
         [NSDecimalNumber decimalNumberWithString:@"100"]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSString *result = [formatter stringFromNumber:pence];
    
    [formatter release];
    return result;
}

+ (UIBarButtonItem *)newCancelButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
            target:target 
            action:@selector(cancel)];    
}

+ (UIBarButtonItem *)newSaveButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
            target:target 
            action:@selector(save)];    
}

+ (UITextField *)newTableCellTextField:(id)delegate {
    UITextField *textField = 
        [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 25)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = delegate;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearsOnBeginEditing = NO;
    return textField;
}   

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message {
	UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:title 
                                   message:message
                                  delegate:nil 
                         cancelButtonTitle:@"OK" 
                         otherButtonTitles:nil];
    [alert show];
	[alert release];
}

+ (void)showAlertWithError:(NSError *)error {
    NSString *message = 
        [NSString stringWithFormat:@"Sorry, %@", [error localizedDescription]];
    [self showAlert:@"Error" withMessage:message];
}


+ (void)handleRemoteError:(NSError *)error {
    if ([error code] == 401) {
        [self showAlert:@"Login Failed" 
            withMessage:@"Please check your username and password, and try again."];
    } else {
        [self showAlertWithError:error];
    }
}

@end
