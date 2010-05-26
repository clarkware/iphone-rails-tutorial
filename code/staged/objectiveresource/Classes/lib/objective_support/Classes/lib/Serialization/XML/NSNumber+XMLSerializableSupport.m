//
//  NSNumber+XMLSerializableSupport.m
//  objective_support
//
//  Created by James Burka on 2/17/09.
//  Copyright 2009 Burkaprojects. All rights reserved.
//

#import "NSObject+XMLSerializableSupport.h"
#import "NSNumber+XMLSerializableSupport.h"


@implementation NSNumber(XMLSerializableSupport)

- (NSString *)toXMLValue {
	return [self stringValue];
}

- (NSString *)toXMLElementAs:(NSString *)rootName excludingInArray:(NSArray *)exclusions
						withTranslations:(NSDictionary *)keyTranslations {
	return [[self class] buildXmlElementAs:rootName withInnerXml:[self toXMLValue] andType:[[self class] xmlTypeFor:self]];
}


@end
