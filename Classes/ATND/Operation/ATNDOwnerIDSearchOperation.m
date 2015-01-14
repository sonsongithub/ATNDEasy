//
//  ATNDOwnerIDSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDOwnerIDSearchOperation.h"

#import "JSON.h"

#define ATND_OWNER_ID_SEARCH_URL @"http://api.atnd.org/events/?owner_id=%d&format=json&start=%d&count=%d"

@implementation ATNDOwnerIDSearchOperation

@synthesize ownerID;

+ (ATNDOwnerIDSearchOperation*)operationWithOwnerIDSearch:(int)ownerID start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_OWNER_ID_SEARCH_URL, ownerID, start, ATND_FETCH_COUNT];
	ATNDOwnerIDSearchOperation *op = [ATNDOwnerIDSearchOperation operationFromURL:[NSURL URLWithString:url]];
	[op setOwnerID:ownerID];
	return op;
}

@end
