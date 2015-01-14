//
//  SQLiteDatabase+event.m
//  ATNDEasy
//
//  Created by sonson on 10/11/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+event.h"

@interface SQLiteDatabase(eventPrivate)
- (BOOL)updateEvent:(ATNDEvent*)event;
- (BOOL)insertEvent:(ATNDEvent*)event;
@end

@implementation SQLiteDatabase(event)

#pragma mark -
#pragma mark Private method

- (BOOL)updateEvent:(ATNDEvent*)event {
	const char *sql = "update event set accepted=?,address=?,catch_=?,description=?,ended_at=?,event_url=?,lat=?,acceptedlimit=?,lon=?,owner_id=?,owner_nickname=?,owner_twitter_id=?,owner_twitter_img=?,place=?,started_at=?,title=?,updated_at=?,url=?,waiting=?,propotionalDescription=?,started_at_sec=? where event_id = ?;";	
	sqlite3_stmt *updateStatement;	
	if (sqlite3_prepare_v2(database, sql, -1, &updateStatement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_int(updateStatement, 1, 10000000);// event.accepted);
		sqlite3_bind_text(updateStatement, 2, [event.address UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStatement, 3, [event.catch_ UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStatement, 4, [event.description UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(updateStatement, 5, [event.ended_at timeIntervalSinceReferenceDate]);
		
		sqlite3_bind_text(updateStatement, 6, [event.event_url UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(updateStatement, 7, event.lat);
		sqlite3_bind_int(updateStatement, 8, event.limit);
		sqlite3_bind_double(updateStatement, 9, event.lon);
		sqlite3_bind_int(updateStatement, 10, event.owner_id);
		sqlite3_bind_text(updateStatement, 11, [event.owner_nickname UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStatement, 12, [event.owner_twitter_id UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStatement, 13, [event.owner_twitter_img UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStatement, 14, [event.place UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(updateStatement, 15, [event.started_at timeIntervalSinceReferenceDate]);
		sqlite3_bind_text(updateStatement, 16, [event.title UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(updateStatement, 17, [event.updated_at timeIntervalSinceReferenceDate]);
		sqlite3_bind_text(updateStatement, 18, [event.url UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(updateStatement, 19, event.waiting);
		sqlite3_bind_text(updateStatement, 20, [event.propotionalDescription UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_double(updateStatement, 21, event.started_at_sec);
		
		sqlite3_bind_int(updateStatement, 22, event.event_id);
		
		/*int success = */sqlite3_step(updateStatement);
	}
	sqlite3_finalize(updateStatement);
	return YES;
}

- (BOOL)insertEvent:(ATNDEvent*)event {
	
	sqlite3_stmt *eventInsertStatement = NULL;
	
	static char *sql = "INSERT INTO event (accepted,address,catch_,description,ended_at,event_id,event_url,lat,acceptedlimit,lon,owner_id,owner_nickname,owner_twitter_id,owner_twitter_img,place,started_at,title,updated_at,url,waiting,propotionalDescription,started_at_sec) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
	
	if (sqlite3_prepare_v2(database, sql, -1, &eventInsertStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_int(eventInsertStatement, 1, event.accepted);
	sqlite3_bind_text(eventInsertStatement, 2, [event.address UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(eventInsertStatement, 3, [event.catch_ UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(eventInsertStatement, 4, [event.description UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(eventInsertStatement, 5, [event.ended_at timeIntervalSinceReferenceDate]);
	sqlite3_bind_int(eventInsertStatement, 6, event.event_id);
	sqlite3_bind_text(eventInsertStatement, 7, [event.event_url UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(eventInsertStatement, 8, event.lat);
	sqlite3_bind_int(eventInsertStatement, 9, event.limit);
	sqlite3_bind_double(eventInsertStatement, 10, event.lon);
	sqlite3_bind_int(eventInsertStatement, 11, event.owner_id);
	sqlite3_bind_text(eventInsertStatement, 12, [event.owner_nickname UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(eventInsertStatement, 13, [event.owner_twitter_id UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(eventInsertStatement, 14, [event.owner_twitter_img UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(eventInsertStatement, 15, [event.place UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(eventInsertStatement, 16, [event.started_at timeIntervalSinceReferenceDate]);
	sqlite3_bind_text(eventInsertStatement, 17, [event.title UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(eventInsertStatement, 18, [event.updated_at timeIntervalSinceReferenceDate]);
	sqlite3_bind_text(eventInsertStatement, 19, [event.url UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(eventInsertStatement, 20, event.waiting);
	sqlite3_bind_text(eventInsertStatement, 21, [event.propotionalDescription UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(eventInsertStatement, 22, event.started_at_sec);
	
	int success = sqlite3_step(eventInsertStatement);
	if (success != SQLITE_ERROR) {
		sqlite3_finalize(eventInsertStatement);
		return YES;
	}
	DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	sqlite3_finalize(eventInsertStatement);
	
	return NO;
}

#pragma mark -
#pragma mark Instance method

- (NSArray*)eventIDs {
	NSMutableArray *array = [NSMutableArray array];
	
	const char *sql = "SELECT event_id from event;";
	sqlite3_stmt *statement = NULL;	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int event_id = sqlite3_column_int(statement, 0);
			[array addObject:[NSNumber numberWithInt:event_id]];
		}
	}
	sqlite3_finalize(statement);
	
	return [NSArray arrayWithArray:array];
}

- (BOOL)deleteEventID:(int)event_id {
	const char *sql = "delete from event where event_id = ?";
	sqlite3_stmt *statement = NULL;	
	int changes = 0;
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_int(statement, 1, event_id);
		sqlite3_step(statement);
		changes = sqlite3_changes(database);
	}
	sqlite3_finalize(statement);
	
	return (changes > 0);
}

- (BOOL)isInsertedEvent:(ATNDEvent*)event {
	
	sqlite3_stmt *checkInsertedStatement = NULL;
	
	static char *sql = "select count(*) from event where event_id = ?";
	
	if (sqlite3_prepare_v2(database, sql, -1, &checkInsertedStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_int(checkInsertedStatement, 1, event.event_id);
	
	int success = sqlite3_step(checkInsertedStatement);
	if (success != SQLITE_ERROR) {
		int count = sqlite3_column_int(checkInsertedStatement, 0);
		sqlite3_finalize(checkInsertedStatement);
		return (count > 0);
	}
	else{
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(checkInsertedStatement);
	
	return NO;
}

- (ATNDEvent*)eventOfEventID:(int)event_id {
	ATNDEvent *event = nil;
	const char *sql = "SELECT accepted,address,catch_,description,ended_at,event_id,event_url,lat,acceptedlimit,lon,owner_id,owner_nickname,owner_twitter_id,owner_twitter_img,place,started_at,title,updated_at,url,waiting,propotionalDescription,started_at_sec from event where event_id = ?";
	sqlite3_stmt *statement = NULL;	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_int(statement, 1, event_id);
		if (sqlite3_step(statement) == SQLITE_ROW) {
			
			event = [[ATNDEvent alloc] init];
			
			char *p = NULL;
			double d = 0;
			
			//			accepted,
			[event setAccepted:sqlite3_column_int(statement, 0)];
			//			address,
			p = (char*)sqlite3_column_int(statement, 1);
			if (p)
				[event setAddress:[NSString stringWithUTF8String:p]];
			//			catch_,
			p = (char *)sqlite3_column_text(statement, 2);
			if (p)
				[event setCatch_:[NSString stringWithUTF8String:p]];
			//			description,
			p = (char *)sqlite3_column_text(statement, 3);
			if (p)
				[event setDescription:[NSString stringWithUTF8String:p]];
			//			ended_at,
			d = sqlite3_column_double(statement, 4);
			if (d > 0)
				[event setEnded_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			event_id,
			[event setEvent_id:sqlite3_column_int(statement, 5)];
			//			event_url,
			p = (char *)sqlite3_column_text(statement, 6);
			if (p)
				[event setEvent_url:[NSString stringWithUTF8String:p]];
			//			lat,
			[event setLat:sqlite3_column_double(statement, 7)];
			//			acceptedlimit,
			[event setLimit:sqlite3_column_int(statement, 8)];
			//			lon,
			[event setLon:sqlite3_column_double(statement, 9)];
			//			owner_id,
			[event setOwner_id:sqlite3_column_int(statement, 10)];
			//			owner_nickname,
			p = (char *)sqlite3_column_text(statement, 11);
			if (p)
				[event setOwner_nickname:[NSString stringWithUTF8String:p]];
			//			owner_twitter_id,
			p = (char *)sqlite3_column_text(statement, 12);
			if (p)
				[event setOwner_twitter_id:[NSString stringWithUTF8String:p]];
			//			owner_twitter_img,
			p = (char *)sqlite3_column_text(statement, 13);
			if (p)
				[event setOwner_twitter_img:[NSString stringWithUTF8String:p]];
			//			place,
			p = (char *)sqlite3_column_text(statement, 14);
			if (p)
				[event setPlace:[NSString stringWithUTF8String:p]];
			//			started_at,
			d = sqlite3_column_double(statement, 15);
			if (d > 0)
				[event setStarted_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			title,
			p = (char *)sqlite3_column_text(statement, 16);
			if (p)
				[event setTitle:[NSString stringWithUTF8String:p]];
			//			updated_at,
			d = sqlite3_column_double(statement, 17);
			if (d > 0)
				[event setUpdated_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			url,
			p = (char *)sqlite3_column_text(statement, 18);
			if (p)
				[event setUrl:[NSString stringWithUTF8String:p]];
			//			waiting,
			[event setWaiting:sqlite3_column_int(statement, 19)];
			//			propotionalDescription,
			p = (char *)sqlite3_column_text(statement, 20);
			if (p)
				[event setPropotionalDescription:[NSString stringWithUTF8String:p]];
			//			started_at_sec
			[event setStarted_at_sec:sqlite3_column_double(statement, 21)];
		}
	}
	sqlite3_finalize(statement);
	
	return event;
}

- (NSArray*)events {
	NSMutableArray *array = [NSMutableArray array];
	
	const char *sql = "SELECT accepted,address,catch_,description,ended_at,event_id,event_url,lat,acceptedlimit,lon,owner_id,owner_nickname,owner_twitter_id,owner_twitter_img,place,started_at,title,updated_at,url,waiting,propotionalDescription,started_at_sec from event";
	sqlite3_stmt *statement = NULL;	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			ATNDEvent *event = [[ATNDEvent alloc] init];
			
			char *p = NULL;
			double d = 0;
			
			//			accepted,
			[event setAccepted:sqlite3_column_int(statement, 0)];
			//			address,
			p = (char*)sqlite3_column_int(statement, 1);
			if (p)
				[event setAddress:[NSString stringWithUTF8String:p]];
			//			catch_,
			p = (char *)sqlite3_column_text(statement, 2);
			if (p)
				[event setCatch_:[NSString stringWithUTF8String:p]];
			//			description,
			p = (char *)sqlite3_column_text(statement, 3);
			if (p)
				[event setDescription:[NSString stringWithUTF8String:p]];
			//			ended_at,
			d = sqlite3_column_double(statement, 4);
			if (d > 0)
				[event setEnded_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			event_id,
			[event setEvent_id:sqlite3_column_int(statement, 5)];
			//			event_url,
			p = (char *)sqlite3_column_text(statement, 6);
			if (p)
				[event setEvent_url:[NSString stringWithUTF8String:p]];
			//			lat,
			[event setLat:sqlite3_column_double(statement, 7)];
			//			acceptedlimit,
			[event setLimit:sqlite3_column_int(statement, 8)];
			//			lon,
			[event setLon:sqlite3_column_double(statement, 9)];
			//			owner_id,
			[event setOwner_id:sqlite3_column_int(statement, 10)];
			//			owner_nickname,
			p = (char *)sqlite3_column_text(statement, 11);
			if (p)
				[event setOwner_nickname:[NSString stringWithUTF8String:p]];
			//			owner_twitter_id,
			p = (char *)sqlite3_column_text(statement, 12);
			if (p)
				[event setOwner_twitter_id:[NSString stringWithUTF8String:p]];
			//			owner_twitter_img,
			p = (char *)sqlite3_column_text(statement, 13);
			if (p)
				[event setOwner_twitter_img:[NSString stringWithUTF8String:p]];
			//			place,
			p = (char *)sqlite3_column_text(statement, 14);
			if (p)
				[event setPlace:[NSString stringWithUTF8String:p]];
			//			started_at,
			d = sqlite3_column_double(statement, 15);
			if (d > 0)
				[event setStarted_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			title,
			p = (char *)sqlite3_column_text(statement, 16);
			if (p)
				[event setTitle:[NSString stringWithUTF8String:p]];
			//			updated_at,
			d = sqlite3_column_double(statement, 17);
			if (d > 0)
				[event setUpdated_at:[NSDate dateWithTimeIntervalSinceReferenceDate:d]];
			//			url,
			p = (char *)sqlite3_column_text(statement, 18);
			if (p)
				[event setUrl:[NSString stringWithUTF8String:p]];
			//			waiting,
			[event setWaiting:sqlite3_column_int(statement, 19)];
			//			propotionalDescription,
			p = (char *)sqlite3_column_text(statement, 20);
			if (p)
				[event setPropotionalDescription:[NSString stringWithUTF8String:p]];
			//			started_at_sec
			[event setStarted_at_sec:sqlite3_column_double(statement, 21)];
			[array addObject:event];
		}
	}
	sqlite3_finalize(statement);
	
	return [NSArray arrayWithArray:array];
}

- (BOOL)insertOrUpdateWithEvent:(ATNDEvent*)event {
	DNSLogMethod
	if ([self isInsertedEvent:event]) {
		DNSLog(@"already inserted");
		
		[self updateEvent:event];
	}
	else {
		DNSLog(@"insert");
		[self insertEvent:event];
	}
	return YES;
}

@end
