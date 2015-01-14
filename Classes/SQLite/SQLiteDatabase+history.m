//
//  SQLiteDatabase+history.m
//  ATNDEasy
//
//  Created by sonson on 10/11/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+history.h"

@implementation SQLiteDatabase(history)


#pragma mark -
#pragma mark Private method

- (BOOL)updateHistoryWithEventID:(int)event_id {
	const char *sql = "update history set date = ? where event_id = ?;";	
	sqlite3_stmt *updateStatement;	
	if (sqlite3_prepare_v2(database, sql, -1, &updateStatement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_double(updateStatement, 1, [NSDate timeIntervalSinceReferenceDate]);
		sqlite3_bind_int(updateStatement, 2, event_id);
		/*int success = */sqlite3_step(updateStatement);
	}
	sqlite3_finalize(updateStatement);
	return YES;
}

- (BOOL)insertHistoryWithEventID:(int)event_id {
	
	sqlite3_stmt *eventInsertStatement = NULL;
	
	static char *sql = "INSERT INTO history (event_id, date) VALUES(?,?);";
	
	if (sqlite3_prepare_v2(database, sql, -1, &eventInsertStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_int(eventInsertStatement, 1, event_id);
	sqlite3_bind_double(eventInsertStatement, 2, [NSDate timeIntervalSinceReferenceDate]);
	
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

- (void)deleteAllHistory {
	sqlite3_stmt *deleteStatement = NULL;
	
	static char *sql = "delete from history;";
	
	if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	/* int success = */sqlite3_step(deleteStatement);
	sqlite3_finalize(deleteStatement);
	return;
}

- (NSTimeInterval)timeIntervalOfEventID:(int)event_id {
	double timeInterval = 0;
	sqlite3_stmt *checkInsertedStatement = NULL;
	
	static char *sql = "select date from history where event_id = ?";
	
	if (sqlite3_prepare_v2(database, sql, -1, &checkInsertedStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return 0;
	}
	
	sqlite3_bind_int(checkInsertedStatement, 1, event_id);
	
	int success = sqlite3_step(checkInsertedStatement);
	if (success != SQLITE_ERROR) {
		timeInterval = sqlite3_column_double(checkInsertedStatement, 0);
		sqlite3_finalize(checkInsertedStatement);
		return timeInterval;
	}
	else{
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(checkInsertedStatement);
	
	return 0;
}

- (BOOL)insertOrUpdateHistoryWithEventID:(int)event_id {
	
	NSTimeInterval r = [self timeIntervalOfEventID:event_id];
	
	if (r > 0) {
		[self updateHistoryWithEventID:event_id];
	}
	else {
		[self insertHistoryWithEventID:event_id];
	}
	
	return NO;
}

@end
