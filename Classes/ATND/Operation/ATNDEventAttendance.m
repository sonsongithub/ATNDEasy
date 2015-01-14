//
//  ATNDEventAttendance.m
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDEventAttendance.h"

#import "JSON.h"

#define ATND_EVENT_ATTENDANCE_URL @"http://api.atnd.org/events/users/?event_id=%d&format=json&start=%d&count=%d"

@implementation ATNDEventAttendance

+ (ATNDEventAttendance*)operationWithAttendanceEventID:(int)eventID start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_EVENT_ATTENDANCE_URL, eventID, start, ATND_FETCH_COUNT];
	ATNDEventAttendance *op = [ATNDEventAttendance operationFromURL:[NSURL URLWithString:url]];
	return op;
}

- (void)doTaskAfterDownloadingData:(NSData*)data {
	// parse jason
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id jsonObject = [str JSONValue];
	[str release];
	
	// get objects from json
	NSArray *events = [jsonObject objectForKey:@"events"];
	NSDictionary *event = [events objectAtIndex:0];
	NSArray *users = [event objectForKey:@"users"];
	
	// parse
	NSMutableArray *newUsers = [NSMutableArray array];

	for (NSDictionary *entry in users) {
		ATNDUser *user = [ATNDUser userFromDictionary:entry];
		[newUsers addObject:user];
	}
	
	// delegate
	NSDictionary *info = [NSDictionary dictionaryWithObject:newUsers forKey:kATNDIncommingUser];
	[target didDownloadOperation:self userInfo:info];
}

- (void)doTaskAfterReturnedDifferentURL {
}

- (void)doTaskAfterFailedDownload:(NSError*)error {
}

@end
