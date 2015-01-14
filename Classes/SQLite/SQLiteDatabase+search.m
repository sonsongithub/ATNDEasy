//
//  SQLiteDatabase+search.m
//  ATNDEasy
//
//  Created by sonson on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+search.h"

static sqlite3_stmt *category_insert_statement = nil;

@interface SQLiteDatabase(search_private)
- (BOOL)insertQuery:(NSString*)query type:(ANTDQueryType)type;
- (BOOL)isInsertedQuery:(NSString*)query;
- (BOOL)updateQuery:(NSString*)query;
@end

@implementation SQLiteDatabase(search)

- (BOOL)insertOrUpdateWithQuery:(NSString*)query type:(ANTDQueryType)type {
	if ([self isInsertedQuery:query]) {
		// already inserted
		[self updateQuery:query];
	}
	else {
		[self insertQuery:query type:type];
	}
	return YES;
}

- (BOOL)insertQuery:(NSString*)query type:(ANTDQueryType)type {
	
	sqlite3_stmt *queryInsertStatement = NULL;
	
	static char *sql = "INSERT INTO search (id, query, type, date) VALUES( NULL, ?, ?, ?)";

	if (sqlite3_prepare_v2(database, sql, -1, &queryInsertStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_text(queryInsertStatement, 1, [query UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(queryInsertStatement, 2, type);
	sqlite3_bind_double(queryInsertStatement, 3, [NSDate timeIntervalSinceReferenceDate]);

	int success = sqlite3_step(queryInsertStatement);
	if (success != SQLITE_ERROR) {
		sqlite3_finalize(queryInsertStatement);
		return NO;
	}
	else{
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_finalize(queryInsertStatement);
	
	return YES;
}

- (BOOL)isInsertedQuery:(NSString*)query {
	
	sqlite3_stmt *checkInsertedStatement = NULL;
	
	static char *sql = "select count(*) from search where query = ?";
	
	if (sqlite3_prepare_v2(database, sql, -1, &checkInsertedStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	sqlite3_bind_text(checkInsertedStatement, 1, [query UTF8String], -1, SQLITE_TRANSIENT);
	
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

- (BOOL)updateQuery:(NSString*)query {
	const char *sql = "update search set date = ? where query = ?";
	
	sqlite3_stmt *updateStatement;	
	if (sqlite3_prepare_v2(database, sql, -1, &updateStatement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_double(updateStatement, 1, [NSDate timeIntervalSinceReferenceDate]);
		sqlite3_bind_text(updateStatement, 2, [query UTF8String], -1, SQLITE_TRANSIENT);
		/*int success = */sqlite3_step(updateStatement);
	}
	sqlite3_finalize(updateStatement);
	return YES;
}

- (NSArray*)candidatesWithQuery:(NSString*)query type:(ANTDQueryType)type {
	NSMutableArray *array = [NSMutableArray array];
	
	const char *sql = "SELECT query from search where type = ? and query like ?";
	sqlite3_stmt *statement = NULL;	
	if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}	
	else {
		sqlite3_bind_int(statement, 1, type);
		NSString* reg = [NSString stringWithFormat:@"%%%@%%", query];
		sqlite3_bind_text(statement, 2, [reg UTF8String], -1, SQLITE_TRANSIENT);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			char *p = (char *)sqlite3_column_text(statement, 0);
			if (p) {
				NSString *found = [NSString stringWithUTF8String:p];
				[array addObject:found];
			}
		}
	}
	sqlite3_finalize(statement);
	
	
	return [NSArray arrayWithArray:array];
}

- (void)deleteAllHistoryOfQuery {
	sqlite3_stmt *deleteStatement = NULL;
	
	static char *sql = "delete from search;";
	
	if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK) {
		DNSLog(@"Error: failed to insert board statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	/* int success = */sqlite3_step(deleteStatement);
	sqlite3_finalize(deleteStatement);
	return;
}

@end
