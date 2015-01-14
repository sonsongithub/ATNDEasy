//
//  ATNDSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDSearchOperation.h"

#import "JSON.h"

#define ATND_KEYWORD_SEARCH_URL @"http://api.atnd.org/events/?keyword=%@&format=json&start=%d&count=%d"

@implementation ATNDSearchOperation

+ (ATNDSearchOperation*)operationWithSearchKeyword:(NSString*)keyword start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_KEYWORD_SEARCH_URL, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], start, ATND_FETCH_COUNT];
	ATNDSearchOperation *op = [ATNDSearchOperation operationFromURL:[NSURL URLWithString:url]];
	return op;
}

- (void)doTaskAfterDownloadingData:(NSData*)data {
	// parse json
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id jsonObject = [str JSONValue];
	[str release];
	
	// get object from json
	NSArray *events = [jsonObject objectForKey:@"events"];
	
	// parse
	NSMutableArray *newEvents = [NSMutableArray array];

	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"atnd_past_event"] == 0) {
		for (NSDictionary *dict in events) {
			ATNDEvent *event = [ATNDEvent eventFromDictionary:dict];
			if (![event isPast]) {
				[newEvents addObject:event];
			}
		}
	}
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"atnd_past_event"] == 1) {
		for (NSDictionary *dict in events) {
			ATNDEvent *event = [ATNDEvent eventFromDictionary:dict];
			[newEvents addObject:event];
		}
	}
	
	NSDictionary *info = [NSDictionary dictionaryWithObject:newEvents forKey:kATNDIncommingEvent];
	[target didDownloadOperation:self userInfo:info];
}

- (void)doTaskAfterReturnedDifferentURL {
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
}

@end
