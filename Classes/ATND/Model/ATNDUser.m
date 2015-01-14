//
//  ATNDUser.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDUser.h"

#import "ATND.h"
#import "NSObject+Null.h"
#import "SQLiteDatabase+history.h"

@implementation ATNDUser

@synthesize nickname, twitter_id, twitter_img;
@synthesize status, user_id;
@synthesize events, ownEvents;
@synthesize numberOfUnread;

@synthesize twitterIcon;

+ (ATNDUser*)userFromDictionary:(NSDictionary*)dictionary {
	ATNDUser *obj = [[ATNDUser alloc] init];
	
	if ([[dictionary objectForKey:@"nickname"] isNotNull]) {
		[obj setNickname:[dictionary objectForKey:@"nickname"]];
	}
	if ([[dictionary objectForKey:@"twitter_id"] isNotNull]) {
		[obj setTwitter_id:[dictionary objectForKey:@"twitter_id"]];
	}
	if ([[dictionary objectForKey:@"twitter_img"] isNotNull]) {
		[obj setTwitter_img:[dictionary objectForKey:@"twitter_img"]];
	}
	
	if ([[dictionary objectForKey:@"status"] isNotNull]) {
		[obj setStatus:[[dictionary objectForKey:@"status"] intValue]];
	}
	if ([[dictionary objectForKey:@"user_id"] isNotNull]) {
		[obj setUser_id:[[dictionary objectForKey:@"user_id"] intValue]];
	}
	
	return [obj autorelease];
}

#pragma mark -
#pragma mark Instance method

- (void)updateNumberOfUnreads {
	NSTimeInterval nowInterval = [NSDate timeIntervalSinceReferenceDate];
	int counter = 0;
	for (ATNDEvent *anEvent in self.events) {
		if ([anEvent.started_at timeIntervalSinceReferenceDate] > nowInterval) {
			NSTimeInterval k = [[SQLiteDatabase sharedInstance] timeIntervalOfEventID:anEvent.event_id];
			if (k > 0) {
			}
			else
				counter++;
		}
	}
	for (ATNDEvent *anEvent in self.ownEvents) {
		if ([anEvent.started_at timeIntervalSinceReferenceDate] > nowInterval) {
			if ([[SQLiteDatabase sharedInstance] timeIntervalOfEventID:anEvent.event_id] > 0) {
			}
			else
				counter++;
		}
	}
	[self setNumberOfUnread:counter];
}

#pragma mark -
#pragma mark coder

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	self.nickname = [coder decodeObjectForKey:@"nickname"];
	self.twitter_id = [coder decodeObjectForKey:@"twitter_id"];
	self.twitter_img = [coder decodeObjectForKey:@"twitter_img"];
	self.status = [coder decodeIntegerForKey:@"status"];
	self.user_id = [coder decodeIntegerForKey:@"user_id"];
	self.events = [NSMutableArray arrayWithArray:[coder decodeObjectForKey:@"events"]];
	self.ownEvents = [NSMutableArray arrayWithArray:[coder decodeObjectForKey:@"ownEvents"]];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.nickname forKey:@"nickname"];
	[encoder encodeObject:self.twitter_id forKey:@"twitter_id"];
	[encoder encodeObject:self.twitter_img forKey:@"twitter_img"];
	[encoder encodeInt:self.status forKey:@"status"];
	[encoder encodeInt:self.user_id forKey:@"user_id"];
	[encoder encodeObject:self.events forKey:@"events"];
	[encoder encodeObject:self.ownEvents forKey:@"ownEvents"];
}

#pragma mark -
#pragma mark Copy

- (id)copyWithZone:(NSZone *)zone {
    ATNDUser *clone =
	[[[self class] allocWithZone:zone] init];
	
	[clone setNickname:[[[self nickname] copy] autorelease]];
	[clone setTwitter_id:[[[self twitter_id] copy] autorelease]];
	[clone setTwitter_img:[[[self twitter_img] copy] autorelease]];
	[clone setStatus:[self status]];
	[clone setUser_id:[self user_id]];
	
	NSMutableArray *newEvents = [NSMutableArray array];
	for (ATNDEvent *event in [self events]) {
		ATNDEvent *copied = [event copy];
		[newEvents addObject:copied];
		[copied release];
	}
	[clone setEvents:newEvents];
	
	NSMutableArray *newOwnEvents = [NSMutableArray array];
	for (ATNDEvent *event in [self ownEvents]) {
		ATNDEvent *copied = [event copy];
		[newOwnEvents addObject:copied];
		[copied release];
	}
	[clone setOwnEvents:newOwnEvents];
	
    return  clone;
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[twitterIcon release];
	[nickname release];
	[twitter_id release];
	[twitter_img release];
	[events release];
	[ownEvents release];
	[super dealloc];
}


@end
