//
//  WatchList.h
//  ATNDEasy
//
//  Created by sonson on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATND.h"

extern NSString *kWatchListUpdatedNumberOfUnread;

@interface WatchList : NSObject {
	NSMutableArray	*watchList;
}
@property (nonatomic, readonly) NSMutableArray	*watchList;
+ (WatchList*)sharedInstance;
- (BOOL)addUser:(ATNDUser*)user;
- (BOOL)addUser:(ATNDUser*)user events:(NSMutableArray*)events ownEvents:(NSMutableArray*)ownEvents;
- (BOOL)removeUser:(ATNDUser*)user;
- (BOOL)isAlreadyWatchingUser:(ATNDUser*)user;
- (void)updateNumberOfUnread;
- (void)postNumberOfUnreadsMessage;
@end
