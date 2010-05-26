#import "AppHelpers.h"

void showAlert(NSString *message) {
    UIAlertView *alert = 
    [[UIAlertView alloc] initWithTitle:@"Whoops" 
                               message:message
                              delegate:nil 
                     cancelButtonTitle:@"OK" 
                     otherButtonTitles:nil];
    [alert show];
    [alert release];
}

NSString* formatDate(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *result = [formatter stringFromDate:date];
    [formatter release];
    return result;
}

NSDate* parseDateTime(NSString *dateTimeString) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *result = [formatter dateFromString:dateTimeString];
    [formatter release];
    return result;
}

NSString * numberToCurrency(NSString *number) {
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