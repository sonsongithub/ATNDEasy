//
//  NSDateFormatter+ATND.m
//  ATNDEasy
//
//  Created by sonson on 10/11/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+ATND.h"

static NSDateFormatter *dateWithW3CFormatter = nil;
static NSDateFormatter *normalDescriptionFormatter = nil;
static NSDateFormatter *shortDescriptionFormatter = nil;

@implementation NSDateFormatter(ATND)

+ (NSDateFormatter*)normalDescriptionFormatter {
	if (normalDescriptionFormatter == nil) {
		normalDescriptionFormatter = [[NSDateFormatter alloc] init];
		[normalDescriptionFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[normalDescriptionFormatter setLocale:[NSLocale currentLocale]];
		[normalDescriptionFormatter setDateFormat:NSLocalizedString(@"MM/dd HH:mm", nil)];
	}
	return normalDescriptionFormatter;
}

+ (NSDateFormatter*)shortDescriptionFormatter {
	if (shortDescriptionFormatter == nil) {
		shortDescriptionFormatter = [[NSDateFormatter alloc] init];
		[shortDescriptionFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[shortDescriptionFormatter setLocale:[NSLocale currentLocale]];
		[shortDescriptionFormatter setDateFormat:NSLocalizedString(@"HH:mm", nil)];
	}
	return shortDescriptionFormatter;
}

+ (NSDateFormatter*)W3CFormatter {
	if (dateWithW3CFormatter == nil) {
		dateWithW3CFormatter = [[NSDateFormatter alloc] init];
		[dateWithW3CFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[dateWithW3CFormatter setLocale:[NSLocale currentLocale]];
		[dateWithW3CFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	}
	return dateWithW3CFormatter;
}

@end
