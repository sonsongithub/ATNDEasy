//
//  ATNDIDSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDIDSearchOperation.h"

#import "JSON.h"

#define ATND_ID_SEARCH_URL @"http://api.atnd.org/events/?user_id=%d&format=json&start=%d&count=%d"

@implementation ATNDIDSearchOperation

@synthesize userID;

+ (ATNDIDSearchOperation*)operationWithIDSearch:(int)userID start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_ID_SEARCH_URL, userID, start, ATND_FETCH_COUNT];
	ATNDIDSearchOperation *op = [ATNDIDSearchOperation operationFromURL:[NSURL URLWithString:url]];
	[op setUserID:userID];
	return op;
}

@end
