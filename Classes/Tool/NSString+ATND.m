//
//  NSString+ATND.m
//  ATNDEasy
//
//  Created by sonson on 10/11/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+ATND.h"
#import "GTMNSString+HTML.h"
#import "NSDateFormatter+ATND.h"

@implementation NSString(ATND)

- (NSString*)stringByRemovingHTMLTags {
	
	const UniChar*p = CFStringGetCharactersPtr((CFStringRef)self);
	
	if(p == NULL)
		return self;
	
	NSMutableString *output = [NSMutableString string];
	
	BOOL insideTag = NO;
	int length = CFStringGetLength((CFStringRef)self);
	
	UniChar br[] = {60, 98, 114, 47, 62};
	UniChar newline[] = {10};
	
	for (int i = 0; i < length; i++) {
		if (length - i > 4) {
			if(memcmp(p+i, br, sizeof(br)) == 0) {
				i+=5;
				CFStringAppendCharacters((CFMutableStringRef)output, newline, 1);
				continue;
			}
		}
		
		if (*(p+i) == 60) {
			insideTag = YES;
		}
		else if (*(p+i) == 62) {
			insideTag = NO;
		}
		else if (*(p+i) == 10) {
			continue;
		}
		else if (!insideTag) {
			CFStringAppendCharacters((CFMutableStringRef)output, (p+i), 1);
		}
	}
	
	return output;
}

- (NSDate*)dateWithW3CFormat {
	NSString *revised = [self stringByReplacingOccurrencesOfString:@"+" withString:@"GMT+"];
	NSDate *date = [[NSDateFormatter W3CFormatter] dateFromString:revised];
	return date;
}

@end
