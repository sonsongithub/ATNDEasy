//
//  ATNDEventSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDEventSearchOperation.h"

#import "ATND.h"
#import "JSON.h"

@implementation ATNDEventSearchOperation

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
	
	
	// make data
	NSString *className = [NSString stringWithUTF8String:class_getName([self class])];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
						  newEvents,		kATNDIncommingEvent,
						  className,		kATNDOperationClassName,
						  nil
						  ];
	
	// delegate
	[target didDownloadOperation:self userInfo:info];
}

- (void)doTaskAfterReturnedDifferentURL {
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
}

@end
