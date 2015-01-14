//
//  SQLiteDatabase+ImageCache.m
//  ATNDEasy
//
//  Created by sonson on 10/11/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+ImageCache.h"

@implementation SQLiteDatabase(ImageCache)

- (int)sizeSumationOfTable:(NSString*)tableName {
	sqlite3_stmt *statement = NULL;
	
	NSString *sqlString = [NSString stringWithFormat:@"select sum(size) from %@;", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_text(statement, 1, [tableName UTF8String], [tableName lengthOfBytesUsingEncoding:NSUTF8StringEncoding], SQLITE_TRANSIENT);
	
	int success = sqlite3_step(statement);
	if (success == SQLITE_ROW) {
		int sum = sqlite3_column_int(statement, 0);
		sqlite3_finalize(statement);
		return sum;
	}
	DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	sqlite3_finalize(statement);
	return 0;
}

- (int)countSumationOfTable:(NSString*)tableName {
	sqlite3_stmt *statement = NULL;
	
	NSString *sqlString = [NSString stringWithFormat:@"select count(*) from %@;", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_text(statement, 1, [tableName UTF8String], [tableName lengthOfBytesUsingEncoding:NSUTF8StringEncoding], SQLITE_TRANSIENT);
	
	int success = sqlite3_step(statement);
	if (success == SQLITE_ROW) {
		int count = sqlite3_column_int(statement, 0);
		sqlite3_finalize(statement);
		return count;
	}
	DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	sqlite3_finalize(statement);
	return 0;
}

- (BOOL)insertTable:(NSString*)tableName binary:(NSData*)binary scale:(float)scale hash:(NSString*)hash {
	sqlite3_stmt *statement = NULL;
	NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO %@ (binary, size, scale, hash, date) VALUES(?,?,?,?,?);", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_blob(statement, 1, [binary bytes], [binary length], SQLITE_TRANSIENT);
	sqlite3_bind_int(statement, 2, [binary length]);
	sqlite3_bind_double(statement, 3, scale);
	sqlite3_bind_text(statement, 4, [hash UTF8String], [hash lengthOfBytesUsingEncoding:NSUTF8StringEncoding], SQLITE_TRANSIENT);
	sqlite3_bind_double(statement, 5, [NSDate timeIntervalSinceReferenceDate]);
	
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
		sqlite3_finalize(statement);
		return YES;
	}
	DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	sqlite3_finalize(statement);
	
	return NO;
}

- (BOOL)selectTable:(NSString*)tableName binary:(NSData**)binary scale:(float*)scale hash:(NSString*)hash {
	sqlite3_stmt *statement = NULL;
	
	NSString *sqlString = [NSString stringWithFormat:@"select binary, scale from %@ where hash = ?;", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_text(statement, 1, [hash UTF8String], [hash lengthOfBytesUsingEncoding:NSUTF8StringEncoding], SQLITE_TRANSIENT);
	
	int success = sqlite3_step(statement);
	if (success == SQLITE_ROW) {
		char *cache = (char*)sqlite3_column_blob(statement, 0);
		int cache_bytes = sqlite3_column_bytes(statement, 0);
		*binary = [NSData dataWithBytes:cache length:cache_bytes];
		*scale = sqlite3_column_double(statement, 1);
		sqlite3_finalize(statement);
		return YES;
	}
	else if (success == SQLITE_ERROR) {
		DNSLogMethod
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	*binary = nil;
	*scale = 0;
	sqlite3_finalize(statement);
	return NO;
}

- (BOOL)updateTable:(NSString*)tableName withHash:(NSString*)hash {
	
	NSString *sqlString = [NSString stringWithFormat:@"update %@ set date = ? where hash = ?;", tableName];
	const char *sql = [sqlString UTF8String];
	
	sqlite3_stmt *statement;	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_double(statement, 1, [NSDate timeIntervalSinceReferenceDate]);
		sqlite3_bind_text(statement, 2, [hash UTF8String], [hash lengthOfBytesUsingEncoding:NSUTF8StringEncoding], SQLITE_TRANSIENT);
		/*int success = */sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	return YES;
}


- (double)getDateFromTable:(NSString*)tableName toBeLeftOffset:(int)countToBeLeftOffset {
	sqlite3_stmt *statement = NULL;
	
	NSString *sqlString = [NSString stringWithFormat:@"select date from %@ order by date limit 1 offset ?", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_int(statement, 1, countToBeLeftOffset);
	int success = sqlite3_step(statement);
	if (success == SQLITE_ROW) {
		double count = sqlite3_column_double(statement, 0);
		sqlite3_finalize(statement);
		return count;
	}
	sqlite3_finalize(statement);
	return 0;
}

- (double)deleteItemFromTable:(NSString*)tableName beforeDate:(double)dateToBeLeft {
	sqlite3_stmt *statement = NULL;
	
	NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where date < ?", tableName];
	const char *sql = [sqlString UTF8String];
	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_double(statement, 1, dateToBeLeft);
	int success =sqlite3_step(statement);
	if (success == SQLITE_ERROR) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(statement);
	return 0;
}

- (BOOL)deleteSurplusOfExistingCache:(NSString*)tableName {
	DNSLogMethod
	
	int sizeSumation = [self sizeSumationOfTable:tableName];
	int count = [self countSumationOfTable:tableName];
	
	DNSLog(@"%d bytes", sizeSumation);
	DNSLog(@"%d items", count);
	
	if (count && sizeSumation) {
		int average = sizeSumation/count;
		DNSLog(@"%d bytes/item", (int)sizeSumation/count);
		
		if (sizeSumation > CACHE_LIMIT_SIZE) {
			int surplus = sizeSumation - CACHE_LIMIT_SIZE;
			int countToBeDeleted = surplus / average;
			int countToBeLeft = count - countToBeDeleted;
			DNSLog(@"%d", countToBeDeleted);
			double dateToBeLeft = [self getDateFromTable:tableName toBeLeftOffset:countToBeLeft];
			DNSLog(@"%f", dateToBeLeft);
			[self deleteItemFromTable:tableName beforeDate:dateToBeLeft];
		}
	}
	return YES;
}

@end
