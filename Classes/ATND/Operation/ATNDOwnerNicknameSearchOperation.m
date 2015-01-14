//
//  ATNDOwnerNicknameSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDOwnerNicknameSearchOperation.h"

#import "JSON.h"

#define ATND_OWNER_NICKNAME_SEARCH_URL @"http://api.atnd.org/events/?owner_nickname=%@&format=json&start=%d&count=%d"

@implementation ATNDOwnerNicknameSearchOperation

+ (ATNDOwnerNicknameSearchOperation*)operationWithSearchNickname:(NSString*)nickname start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_OWNER_NICKNAME_SEARCH_URL, nickname, start, ATND_FETCH_COUNT];
	ATNDOwnerNicknameSearchOperation *op = [ATNDOwnerNicknameSearchOperation operationFromURL:[NSURL URLWithString:url]];
	return op;
}

@end
