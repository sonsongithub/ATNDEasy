//
//  ATNDUserSearchOperation.m
//  ATNDEasy
//
//  Created by sonson on 10/11/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDNicknameSearchOperation.h"

#import "JSON.h"

#define ATND_NICKNAME_SEARCH_URL @"http://api.atnd.org/events/?nickname=%@&format=json&start=%d&count=%d"

@implementation ATNDNicknameSearchOperation

+ (ATNDNicknameSearchOperation*)operationWithSearchNickname:(NSString*)nickname start:(int)start {
	NSString *url = [NSString stringWithFormat:ATND_NICKNAME_SEARCH_URL, nickname, start, ATND_FETCH_COUNT];
	ATNDNicknameSearchOperation *op = [ATNDNicknameSearchOperation operationFromURL:[NSURL URLWithString:url]];
	return op;
}

@end
