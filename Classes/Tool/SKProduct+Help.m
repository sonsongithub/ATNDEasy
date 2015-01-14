//
//  SKProduct+Help.m
//  ATNDEasy
//
//  Created by sonson on 10/11/25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SKProduct+Help.h"


@implementation SKProduct(Help)

- (NSString*)formattedPriceString {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:self.priceLocale];
	NSString *formattedString = [numberFormatter stringFromNumber:self.price];
	[numberFormatter release];
	return formattedString;
}

@end
