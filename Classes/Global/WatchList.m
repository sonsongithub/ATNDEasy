//
//  WatchList.m
//  ATNDEasy
//
//  Created by sonson on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WatchList.h"
#import "SQLiteDatabase+history.h"

WatchList *sharedWatchList = nil;

NSString *kWatchListUpdatedNumberOfUnread = @"kWatchListUpdatedNumberOfUnread";

@implementation WatchList

@synthesize watchList;

#pragma mark -
#pragma mark Class method

+ (WatchList*)sharedInstance {
	if (sharedWatchList == nil) {
		sharedWatchList = [[WatchList alloc] init];
	}
	return sharedWatchList;
}

#pragma mark -
#pragma mark Instance method

- (void)updateNumberOfUnread {
	DNSLogMethod
	for (ATNDUser *aUser in watchList) {
		[aUser updateNumberOfUnreads];
	}
	[self postNumberOfUnreadsMessage];
}

- (void)postNumberOfUnreadsMessage {
	int unreads = 0;
	for (ATNDUser *aUser in watchList) {
		unreads += aUser.numberOfUnread;
	}
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", unreads] forKey:@"WatchListNumberOfUnread"];
	[[NSNotificationCenter defaultCenter] postNotificationName:kWatchListUpdatedNumberOfUnread object:nil userInfo:userInfo];
}

- (BOOL)addUser:(ATNDUser*)user {
	for (ATNDUser *aUser in watchList) {
		if (aUser.user_id == user.user_id)
			return NO;
	}
	return YES;
}

- (BOOL)updateUser:(ATNDUser*)user events:(NSMutableArray*)events ownEvents:(NSMutableArray*)ownEvents {
	for (ATNDUser *aUser in watchList) {
		if (aUser.user_id == user.user_id) {
			
			[aUser setEvents:events];
			[aUser setOwnEvents:ownEvents];
			
			[self updateNumberOfUnread];
			
			return YES;
		}
	}
	
	[user setEvents:events];
	[user setOwnEvents:ownEvents];
	ATNDUser *copied = [user copy];
	[watchList addObject:copied];
	[copied release];
	[user setEvents:nil];
	[user setOwnEvents:nil];
	
	[copied updateNumberOfUnreads];
	[self postNumberOfUnreadsMessage];
	
	return NO;
}

- (BOOL)addUser:(ATNDUser*)user events:(NSMutableArray*)events ownEvents:(NSMutableArray*)ownEvents {
	for (ATNDUser *aUser in watchList) {
		if (aUser.user_id == user.user_id)
			return NO;
	}
	
	[user setEvents:events];
	[user setOwnEvents:ownEvents];
	ATNDUser *copied = [user copy];
	[watchList addObject:copied];
	[copied release];
	[user setEvents:nil];
	[user setOwnEvents:nil];
	
	[copied updateNumberOfUnreads];
	[self postNumberOfUnreadsMessage];
	
	return YES;
}

- (BOOL)removeUser:(ATNDUser*)user {
	for (ATNDUser *aUser in watchList) {
		if (aUser.user_id == user.user_id) {
			[watchList removeObject:aUser];
			return NO;
		}
	}
	return NO;
}

- (BOOL)isAlreadyWatchingUser:(ATNDUser*)user {
	for (ATNDUser *aUser in watchList) {
		if (aUser.user_id == user.user_id) {
			return YES;
		}
	}
	return NO;
}

- (void)save {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[encoder encodeObject:watchList forKey:@"WatchList"];
	[encoder finishEncoding];
	[encoder release];
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *plistPath = [NSString stringWithFormat:@"%@/WatchList.plist", documentsDirectory ];
	
	[data writeToFile:plistPath atomically:NO];
	[data release];
}

- (void)load {
	DNSLogMethod
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *plistPath = [NSString stringWithFormat:@"%@/WatchList.plist", documentsDirectory ];
	if( [[NSFileManager defaultManager] fileExistsAtPath:plistPath] ) {
		NSData *data  = [NSData dataWithContentsOfFile:plistPath];
		NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		
		NSArray *incomming = [decoder decodeObjectForKey:@"WatchList"];
		if (incomming == nil) {
		}
		else {
			[watchList removeAllObjects];
			[watchList addObjectsFromArray:incomming];
		}
		
		[decoder finishDecoding];
		[decoder release];
	}
	
	[self updateNumberOfUnread];
}

#pragma mark -
#pragma mark Override

- (id) init {
	self = [super init];
	if (self != nil) {
		watchList = [[NSMutableArray array] retain];
		// auto save
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationDidEnterBackgroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
		[self load];
	}
	return self;
}

#pragma mark -
#pragma mark Singleton pattern

- (id)retain {
	return self;
}

- (void)release {
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[watchList release];
	[super dealloc];
}

@end
