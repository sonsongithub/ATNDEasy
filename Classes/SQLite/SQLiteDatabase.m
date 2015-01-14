//
//  SQLiteDatabase.m
//  2tch
//
//  Created by sonson on 09/07/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase.h"

// category
#import "SQLiteDatabase+StaticMapCache.m"
#import "SQLiteDatabase+twitterIconCache.h"

SQLiteDatabase* sharedSQLiteDatabase = nil;

@implementation SQLiteDatabase

+ (SQLiteDatabase*)sharedInstance {
	if (sharedSQLiteDatabase == nil) {
		sharedSQLiteDatabase = [[SQLiteDatabase alloc] init];
	}
	return sharedSQLiteDatabase;
}

- (id)init {
	if (self = [super init]) {
		[self createEditableCopyOfDatabaseIfNeeded];
		[self initializeDatabase];
		
		// create table
		[self createTableStaticMapCache];
		[self createTwitterIconCache];
	}
	return self;
}

- (void)startTransaction {
	sqlite3_exec(database, "BEGIN", NULL, NULL, NULL);
}

- (void)endTransaction {
	sqlite3_exec(database, "COMMIT", NULL, NULL, NULL);
	sqlite3_exec(database, "END", NULL, NULL, NULL);
}

- (void)initializeDatabase {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ATNDEasy.sql"];
	
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		sqlite3_exec(database, "PRAGMA auto_vacuum=1", NULL, NULL, NULL );
    }
	else {
		DNSLog(@"Can't open datbase file");
		sqlite3_close(database);
	}
}

- (void)createEditableCopyOfDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ATNDEasy.sql"];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) {
		return;
	}
	
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ATNDEasy.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
		DNSLog(@"Can't open datbase file - %@", [error localizedDescription]);
    }
	else
		DNSLog(@"Created editable copy of database.");
}

#pragma mark -
#pragma mark singleton design pattern

- (id)retain {
	return self;
}

- (void)release {
}

@end
