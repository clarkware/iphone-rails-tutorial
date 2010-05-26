//
//  NSArray+JSONSerializableSupport.h
//  objective_support
//
//  Created by James Burka on 2/16/09.
//  Copyright 2009 Burkaprojects. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSArray(JSONSerializableSupport)

- (NSString *)toJSONAs:(NSString *)rootName excludingInArray:(NSArray *)exclusions
			withTranslations:(NSDictionary *)keyTranslations;

@end
