//
//  ATNDEvent.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATND.h"

int startedAtSort(id val1, id val2, void *context);

@interface ATNDEvent : NSObject {
	int				accepted;
	NSString		*address;
	NSString		*catch_;
	NSString		*description;
	NSDate			*ended_at;
	int				event_id;
	NSString		*event_url;
	float			lat;
	int				limit;
	float			lon;
    int				owner_id;
	NSString		*owner_nickname;
	NSString		*owner_twitter_id;
	NSString		*owner_twitter_img;
	NSString		*place;
	NSDate			*started_at;
	NSString		*title;
	NSDate			*updated_at;
	NSString		*url;
	int				waiting;
	
	// addtional data
	NSString		*propotionalDescription;
	NSTimeInterval	started_at_sec;
	
	// this data is not serialized
	BOOL			unread;
}

@property (nonatomic, assign) int		accepted;
@property (nonatomic, retain) NSString	*address;
@property (nonatomic, retain) NSString	*catch_;
@property (nonatomic, retain) NSString	*description;
@property (nonatomic, retain) NSDate	*ended_at;
@property (nonatomic, assign) int		event_id;
@property (nonatomic, retain) NSString	*event_url;
@property (nonatomic, assign) float		lat;
@property (nonatomic, assign) int		limit;
@property (nonatomic, assign) float		lon;
@property (nonatomic, assign) int		owner_id;
@property (nonatomic, retain) NSString	*owner_nickname;
@property (nonatomic, retain) NSString	*owner_twitter_id;
@property (nonatomic, retain) NSString	*owner_twitter_img;
@property (nonatomic, retain) NSString	*place;
@property (nonatomic, retain) NSDate	*started_at;
@property (nonatomic, retain) NSString	*title;
@property (nonatomic, retain) NSDate	*updated_at;
@property (nonatomic, retain) NSString	*url;
@property (nonatomic, assign) int		waiting;
@property (nonatomic, assign) NSTimeInterval started_at_sec;
@property (nonatomic, retain) NSString	*propotionalDescription;

@property (nonatomic, assign) BOOL		unread;

+ (UIFont*)fontForDescription;
+ (float)widthForDescription;
+ (float)heightForTruncatedDescription;

+ (ATNDEvent*)eventFromUserInfo:(NSDictionary*)dict;
- (NSDictionary*)userInfo;

+ (ATNDEvent*)eventFromDictionary:(NSDictionary*)dictionary;
- (float)heightOfDescription;
- (float)heightOfTruncatedDescription;
- (BOOL)isPast;
- (UILocalNotification*)localNotificationWithMessage:(NSString*)message before:(NSTimeInterval)before;
- (void)updateUnreadStatus;
@end
