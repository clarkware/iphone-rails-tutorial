//
//  ObjectiveResourceDateFormatter.h
//  iphone-harvest
//
//  Created by James Burka on 10/21/08.
//  Copyright 2008 Burkaprojects. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ObjectiveResourceDateFormatter : NSObject 

typedef enum {
	Date = 0,
	DateTime,
} ORSDateFormat;

+ (void)setSerializeFormat:(ORSDateFormat)dateFormat;
+ (void)setDateFormatString:(NSString *)format;
+ (void)setDateTimeFormatString:(NSString *)format;
+ (void)setDateTimeZoneFormatString:(NSString *)format;
+ (NSString *)formatDate:(NSDate *)date;
+ (NSDate *)parseDate:(NSString *)dateString;
+ (NSDate *)parseDateTime:(NSString *)dateTimeString;

@end
