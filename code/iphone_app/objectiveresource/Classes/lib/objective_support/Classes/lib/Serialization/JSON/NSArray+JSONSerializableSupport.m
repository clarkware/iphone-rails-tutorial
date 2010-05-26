//
//  NSArray+JSONSerializableSupport.m
//  objective_support
//
//  Created by James Burka on 2/16/09.
//  Copyright 2009 Burkaprojects. All rights reserved.
//

#import "JSONFramework.h"
#import "NSObject+JSONSerializableSupport.h"
#import "NSArray+JSONSerializableSupport.h"


@implementation NSArray(JSONSerializableSupport)

- (NSString *)toJSONAs:(NSString *)rootName excludingInArray:(NSArray *)exclusions
			withTranslations:(NSDictionary *)keyTranslations {

	NSMutableString *values = [NSMutableString  stringWithString:@"["];
	BOOL comma = NO;
	for (id element in self) {
		if(comma) {
			[values appendString:@","];
		}
		else {
			comma = YES;
		}
		[values appendString:[element toJSONAs:[element jsonClassName] excludingInArray:exclusions withTranslations:keyTranslations]];
		
	}
	[values appendString:@"]"];
	return values;
}

@end
