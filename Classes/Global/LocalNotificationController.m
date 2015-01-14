//
//  LocalNotificationController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocalNotificationController.h"

#import "SQLiteDatabase+event.h"

LocalNotificationController *sharedLocalNotificationController = nil;

@implementation LocalNotificationController

#pragma mark -
#pragma mark Class method

+ (LocalNotificationController*)sharedInstance {
	if (sharedLocalNotificationController == nil) {
		sharedLocalNotificationController = [[LocalNotificationController alloc] init];
	}
	return sharedLocalNotificationController;
}

- (void)addEvent:(ATNDEvent*)event {
	UILocalNotification *notification = [event localNotificationWithMessage:@"" before:0];
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addEvent:(ATNDEvent*)event message:(NSString*)message before:(NSTimeInterval)before {
	UILocalNotification *notification = [event localNotificationWithMessage:message before:before];
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (BOOL)isScheduledEvent:(ATNDEvent*)event {
	NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	
	for (UILocalNotification *notification in localNotifications) {
		NSDictionary *d = [notification.userInfo objectForKey:@"event"];
		int event_id = [[d objectForKey:@"event_id"] intValue];
		if (event.event_id == event_id) {
			return YES;
		}
	}
	return NO;
}

- (NSArray*)scheduledEvents {
	
	NSMutableArray *array = [NSMutableArray array];
	
	NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	
	for (UILocalNotification *notification in localNotifications) {
		NSDictionary *d = [notification.userInfo objectForKey:@"event"];
		[array addObject:[ATNDEvent eventFromUserInfo:d]];
	}
	return [NSArray arrayWithArray:array];
}

- (BOOL)cancelEvent:(ATNDEvent*)event {
	NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for (UILocalNotification *notification in notifications) {
		NSDictionary *d = [notification.userInfo objectForKey:@"event"];
		ATNDEvent *p = [ATNDEvent eventFromUserInfo:d];
		if (p.event_id == event.event_id) {
			[[UIApplication sharedApplication] cancelLocalNotification:notification];
			return YES;
		}
	}
	return NO;
}

#pragma mark -
#pragma mark Singleton pattern

- (id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (id)retain {
	return self;
}

- (void)release {
}

@end
