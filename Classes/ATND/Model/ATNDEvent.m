//
//  ATNDEvent.m
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNDEvent.h"

#import "SQLiteDatabase+history.h"
#import "NSObject+Null.h"

int startedAtSort(id val1, id val2, void *context) {
	if (((ATNDEvent*)val1).started_at_sec > ((ATNDEvent*)val2).started_at_sec)
		return NSOrderedAscending;
	else if (((ATNDEvent*)val1).started_at_sec < ((ATNDEvent*)val2).started_at_sec)
		return NSOrderedDescending;
	else return NSOrderedSame;
}

@implementation ATNDEvent

@synthesize accepted, address,catch_,description,ended_at,event_id,event_url,lat,limit,lon;
@synthesize owner_id,owner_nickname,owner_twitter_id,owner_twitter_img,place;
@synthesize started_at,title,updated_at,url,waiting;
@synthesize propotionalDescription;
@synthesize started_at_sec;
@synthesize unread;

#pragma mark -
#pragma mark Class method

+ (UIFont*)fontForDescription {
	return [UIFont boldSystemFontOfSize:12];
}

+ (float)widthForDescription {
	return 280;
}

+ (float)heightForTruncatedDescription {
	return 150;
}

#pragma mark -
#pragma mark Make instace from JSON

+ (ATNDEvent*)eventFromDictionary:(NSDictionary*)dictionary {
	ATNDEvent *obj = [[ATNDEvent alloc] init];
	
	if ([[dictionary objectForKey:@"accepted"] isNotNull]) {
		[obj setAccepted:[[dictionary objectForKey:@"accepted"] intValue]];
	}
	if ([[dictionary objectForKey:@"address"] isNotNull]) {
		[obj setAddress:[dictionary objectForKey:@"address"]];
	}
	if ([[dictionary objectForKey:@"catch_"] isNotNull]) {
		[obj setCatch_:[dictionary objectForKey:@"catch_"]];
	}
	if ([[dictionary objectForKey:@"description"] isNotNull]) {
		[obj setDescription:[dictionary objectForKey:@"description"]];
	}
	if ([[dictionary objectForKey:@"ended_at"] isNotNull]) {
		NSString *ended_at = [dictionary objectForKey:@"ended_at"];
		[obj setEnded_at:[ended_at dateWithW3CFormat]];
	}
	
	if ([[dictionary objectForKey:@"event_id"] isNotNull]) {
		[obj setEvent_id:[[dictionary objectForKey:@"event_id"] intValue]];
	}
	if ([[dictionary objectForKey:@"event_url"] isNotNull]) {
		[obj setEvent_url:[dictionary objectForKey:@"event_url"]];
	}
	if ([[dictionary objectForKey:@"lat"] isNotNull]) {
		[obj setLat:[[dictionary objectForKey:@"lat"] floatValue]];
	}
	if ([[dictionary objectForKey:@"limit"] isNotNull]) {
		if ([dictionary objectForKey:@"limit"] != [NSNull null]) {
			[obj setLimit:[[dictionary objectForKey:@"limit"] intValue]];
		}
	}
	if ([[dictionary objectForKey:@"lon"] isNotNull]) {
		[obj setLon:[[dictionary objectForKey:@"lon"] floatValue]];
	}
	
	if ([[dictionary objectForKey:@"owner_id"] isNotNull]) {
		[obj setOwner_id:[[dictionary objectForKey:@"owner_id"] intValue]];
	}
	if ([[dictionary objectForKey:@"owner_nickname"] isNotNull]) {
		[obj setOwner_nickname:[dictionary objectForKey:@"owner_nickname"]];
	}
	if ([[dictionary objectForKey:@"owner_twitter_id"] isNotNull]) {
		[obj setOwner_twitter_id:[dictionary objectForKey:@"owner_twitter_id"]];
	}
	if ([[dictionary objectForKey:@"owner_twitter_img"] isNotNull]) {
		[obj setOwner_twitter_img:[dictionary objectForKey:@"owner_twitter_img"]];
	}
	if ([[dictionary objectForKey:@"place"] isNotNull]) {
		[obj setPlace:[dictionary objectForKey:@"place"]];
	}
	if ([[dictionary objectForKey:@"started_at"] isNotNull]) {
		NSString *started_at_string = [dictionary objectForKey:@"started_at"];
		[obj setStarted_at:[started_at_string dateWithW3CFormat]];
#ifdef _TEST_1_DAY
		[obj setStarted_at:[[NSDate date] dateByAddingTimeInterval:3600 * 24 + 10]];
#endif
#ifdef _TEST_HALF_DAY
		[obj setStarted_at:[[NSDate date] dateByAddingTimeInterval:3600 * 12 + 10]];
#endif
#ifdef _TEST_1_HOUR
		[obj setStarted_at:[[NSDate date] dateByAddingTimeInterval:3600 + 10]];
#endif	
		obj.started_at_sec = [obj.started_at timeIntervalSinceReferenceDate];
	}
	if ([[dictionary objectForKey:@"title"] isNotNull]) {
		[obj setTitle:[dictionary objectForKey:@"title"]];
	}
	if ([[dictionary objectForKey:@"updated_at"] isNotNull]) {
		NSString *updated_at = [dictionary objectForKey:@"updated_at"];
		[obj setUpdated_at:[updated_at dateWithW3CFormat]];
	}
	if ([[dictionary objectForKey:@"url"] isNotNull]) {
		[obj setUrl:[dictionary objectForKey:@"url"]];
	}
	if ([[dictionary objectForKey:@"waiting"] isNotNull]) {
		[obj setWaiting:[[dictionary objectForKey:@"waiting"] intValue]];
	}
	
	[obj updateUnreadStatus];
	
	return [obj autorelease];
}

#pragma mark -
#pragma mark Write and read, NSDictionary

+ (ATNDEvent*)eventFromUserInfo:(NSDictionary*)dict {
	ATNDEvent *obj = [[ATNDEvent alloc] init];
	
	[obj setAccepted:[[dict objectForKey:@"accepted"] intValue]];
	[obj setAddress:[dict objectForKey:@"address"]];
	[obj setCatch_:[dict objectForKey:@"catch"]];
	[obj setDescription:[dict objectForKey:@"description"]];
	[obj setEnded_at:[NSDate dateWithTimeIntervalSinceReferenceDate:[[dict objectForKey:@"ended_at"] doubleValue]]];

	
	[obj setEvent_id:[[dict objectForKey:@"event_id"] intValue]];
	[obj setEvent_url:[dict objectForKey:@"event_url"]];
	[obj setLat:[[dict objectForKey:@"lat"] floatValue]];
	[obj setLimit:[[dict objectForKey:@"limit"] intValue]];
	[obj setLon:[[dict objectForKey:@"lon"] floatValue]];
	
	[obj setOwner_id:[[dict objectForKey:@"owner_id"] intValue]];
	[obj setOwner_nickname:[dict objectForKey:@"owner_nickname"]];
	[obj setOwner_twitter_id:[dict objectForKey:@"owner_twitter_id"]];
	[obj setOwner_twitter_img:[dict objectForKey:@"owner_twitter_img"]];
	[obj setPlace:[dict objectForKey:@"place"]];
	
	[obj setStarted_at:[NSDate dateWithTimeIntervalSinceReferenceDate:[[dict objectForKey:@"started_at"] doubleValue]]];
	[obj setTitle:[dict objectForKey:@"title"]];
	[obj setUpdated_at:[NSDate dateWithTimeIntervalSinceReferenceDate:[[dict objectForKey:@"updated_at"] doubleValue]]];
	[obj setUrl:[dict objectForKey:@"url"]];
	[obj setWaiting:[[dict objectForKey:@"waiting"] intValue]];
	
	[obj setUrl:[dict objectForKey:@"url"]];
	[obj setStarted_at_sec:[[dict objectForKey:@"started_at_sec"] doubleValue]];
	
	[obj updateUnreadStatus];
	
	return [obj autorelease];
}

- (NSDictionary*)userInfo {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:[NSNumber numberWithInt:self.accepted] forKey:@"accepted"];
	
	if ([self.address length])
		[dict setObject:self.address forKey:@"address"];
	if ([self.catch_ length])
		[dict setObject:self.catch_ forKey:@"catch"];
	if ([self.description length])
	[dict setObject:self.description forKey:@"description"];
	[dict setObject:[NSNumber numberWithDouble:[self.ended_at timeIntervalSinceReferenceDate]] forKey:@"ended_at"];
	
	[dict setObject:[NSNumber numberWithInt:self.event_id] forKey:@"event_id"];
	if ([self.event_url length])
	[dict setObject:self.event_url forKey:@"event_url"];
	[dict setObject:[NSNumber numberWithFloat:self.lat] forKey:@"lat"];
	[dict setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
	[dict setObject:[NSNumber numberWithFloat:self.lon] forKey:@"lon"];
	
	[dict setObject:[NSNumber numberWithInt:self.owner_id] forKey:@"owner_id"];
	if ([self.owner_nickname length])
		[dict setObject:self.owner_nickname forKey:@"owner_nickname"];
	if ([self.owner_twitter_id length])
		[dict setObject:self.owner_twitter_id forKey:@"owner_twitter_id"];
	if ([self.owner_twitter_img length])
		[dict setObject:self.owner_twitter_img forKey:@"owner_twitter_img"];
	if ([self.place length])
	[dict setObject:self.place forKey:@"place"];
	
	[dict setObject:[NSNumber numberWithDouble:[self.started_at timeIntervalSinceReferenceDate]] forKey:@"started_at"];
	if ([self.title length])
	[dict setObject:self.title forKey:@"title"];
	[dict setObject:[NSNumber numberWithDouble:[self.updated_at timeIntervalSinceReferenceDate]] forKey:@"updated_at"];
	if ([self.url length])
	[dict setObject:self.url forKey:@"url"];
	[dict setObject:[NSNumber numberWithInt:self.waiting] forKey:@"waiting"];
	
	if ([self.catch_ length])
	[dict setObject:self.propotionalDescription forKey:@"propotionalDescription"];
	[dict setObject:[NSNumber numberWithDouble:self.started_at_sec] forKey:@"started_at_sec"];
	
	return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark -
#pragma mark NSCoder

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	
	NSTimeInterval temp = 0;
	
	self.accepted = [coder decodeIntegerForKey:@"accepted"];
	self.address = [coder decodeObjectForKey:@"address"];
	self.catch_ = [coder decodeObjectForKey:@"catch_"];
	self.description = [coder decodeObjectForKey:@"description"];
	temp = [coder decodeDoubleForKey:@"ended_at"];
	self.ended_at = [NSDate dateWithTimeIntervalSinceReferenceDate:temp];
	
	self.event_id = [coder decodeIntegerForKey:@"event_id"];
	self.event_url = [coder decodeObjectForKey:@"event_url"];
	self.lat = [coder decodeFloatForKey:@"lat"];
	self.limit = [coder decodeIntegerForKey:@"limit"];
	self.lon = [coder decodeFloatForKey:@"lon"];
	
	self.owner_id = [coder decodeIntegerForKey:@"owner_id"];
	self.owner_nickname = [coder decodeObjectForKey:@"owner_nickname"];
	self.owner_twitter_id = [coder decodeObjectForKey:@"owner_twitter_id"];
	self.owner_twitter_img = [coder decodeObjectForKey:@"owner_twitter_img"];
	self.place = [coder decodeObjectForKey:@"place"];
	
	temp = [coder decodeDoubleForKey:@"started_at"];
	self.started_at = [NSDate dateWithTimeIntervalSinceReferenceDate:temp];
	self.title = [coder decodeObjectForKey:@"title"];
	temp = [coder decodeDoubleForKey:@"updated_at"];
	self.updated_at = [NSDate dateWithTimeIntervalSinceReferenceDate:temp];
	self.url = [coder decodeObjectForKey:@"url"];
	self.waiting = [coder decodeIntegerForKey:@"waiting"];
	
	started_at_sec = [started_at timeIntervalSinceReferenceDate];
	
	[self updateUnreadStatus];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {	
	[encoder encodeInteger:self.accepted forKey:@"accepted"];
	[encoder encodeObject:self.address forKey:@"address"];
	[encoder encodeObject:self.catch_ forKey:@"catch_"];
	[encoder encodeObject:self.description forKey:@"description"];
	[encoder encodeDouble:[self.ended_at timeIntervalSinceReferenceDate] forKey:@"ended_at"];
	
	[encoder encodeInteger:self.event_id forKey:@"event_id"];
	[encoder encodeObject:self.event_url forKey:@"event_url"];
	[encoder encodeFloat:self.lat forKey:@"lat"];
	[encoder encodeInteger:self.limit forKey:@"limit"];
	[encoder encodeFloat:self.lon forKey:@"lon"];
	
	[encoder encodeInteger:self.owner_id forKey:@"owner_id"];
	[encoder encodeObject:self.owner_nickname forKey:@"owner_nickname"];
	[encoder encodeObject:self.owner_twitter_id forKey:@"owner_twitter_id"];
	[encoder encodeObject:self.owner_twitter_img forKey:@"owner_twitter_img"];
	[encoder encodeObject:self.place forKey:@"place"];
	
	[encoder encodeDouble:[self.started_at timeIntervalSinceReferenceDate] forKey:@"started_at"];
	[encoder encodeObject:self.title forKey:@"title"];
	[encoder encodeDouble:[self.updated_at timeIntervalSinceReferenceDate] forKey:@"updated_at"];
	[encoder encodeObject:self.url forKey:@"url"];
	[encoder encodeInteger:self.waiting forKey:@"waiting"];
}

#pragma mark -
#pragma mark Copy

- (id)copyWithZone:(NSZone *)zone {
    ATNDEvent *clone =
	[[[self class] allocWithZone:zone] init];
	
    [clone setAccepted:[self accepted]];
	[clone setAddress:[[[self address] copy] autorelease]];
	[clone setCatch_:[[[self catch_] copy] autorelease]];
	[clone setDescription:[[[self description] copy] autorelease]];
	[clone setEnded_at:[[[self ended_at] copy] autorelease]];
	
	[clone setEvent_id:[self event_id]];
	[clone setEvent_url:[[[self event_url] copy] autorelease]];
	[clone setLat:[self lat]];
	[clone setLimit:[self limit]];
	[clone setLon:[self lon]];
	
	[clone setOwner_id:[self owner_id]];
	[clone setOwner_nickname:[[[self owner_nickname] copy] autorelease]];
	[clone setOwner_twitter_id:[[[self owner_twitter_id] copy] autorelease]];
	[clone setOwner_twitter_img:[[[self owner_twitter_img] copy] autorelease]];
	[clone setPlace:[[[self place] copy] autorelease]];
	
	[clone setStarted_at:[[[self started_at] copy] autorelease]];
	[clone setTitle:[[[self title] copy] autorelease]];
	[clone setUpdated_at:[[[self updated_at] copy] autorelease]];
	[clone setUrl:[[[self url] copy] autorelease]];
	[clone setWaiting:[self waiting]];
	
    return  clone;
}

#pragma mark -
#pragma mark Instance method

- (NSString*)propotionalDescription {
	if (propotionalDescription == nil) {
		propotionalDescription = [description stringByRemovingHTMLTags];
		[propotionalDescription retain];
	}
	return propotionalDescription;
}

- (float)heightOfDescription {
	CGSize size = [self.propotionalDescription sizeWithFont:[ATNDEvent fontForDescription] 
										  constrainedToSize:CGSizeMake([ATNDEvent widthForDescription], 1000000)
											  lineBreakMode:UILineBreakModeCharacterWrap];
	return size.height;
}

- (float)heightOfTruncatedDescription {
	CGSize size = [self.propotionalDescription sizeWithFont:[ATNDEvent fontForDescription] 
										  constrainedToSize:CGSizeMake([ATNDEvent widthForDescription], [ATNDEvent heightForTruncatedDescription])
											  lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
}

- (BOOL)isPast {
	return ([[NSDate date] earlierDate:self.started_at] == self.started_at);
}

- (UILocalNotification*)localNotificationWithMessage:(NSString*)message before:(NSTimeInterval)before {
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	
	
	localNotif.fireDate = [self.started_at dateByAddingTimeInterval:-before];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil), self.title, message];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
	localNotif.applicationIconBadgeNumber = 0;
	
	localNotif.alertLaunchImage = @"LocalNotification.png";
	
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[self userInfo] forKey:@"event"];
    localNotif.userInfo = infoDict;
	
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	
	return [localNotif autorelease];
}

- (void)updateUnreadStatus {
	NSTimeInterval aHistory = [[SQLiteDatabase sharedInstance] timeIntervalOfEventID:self.event_id];
	NSTimeInterval update_time = [self.updated_at timeIntervalSinceReferenceDate];
	self.unread = (aHistory < update_time);
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[address release];
	[catch_ release];
	[description release];
	[ended_at release];
	[event_url release];
	[owner_nickname release];
	[owner_twitter_id release];
	[owner_twitter_img release];
	[place release];
	[started_at release];
	[title release];
	[updated_at release];
	[url release];
	
	[propotionalDescription release];
	
	[super dealloc];
}


@end
