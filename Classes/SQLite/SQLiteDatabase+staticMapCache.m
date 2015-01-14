//
//  SQLiteDatabase+staticMapCache.m
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+staticMapCache.h"
#import "SQLiteDatabase+ImageCache.h"

@implementation SQLiteDatabase(staticMapCache)

- (void)createTableStaticMapCache {
	sqlite3_exec(database, "CREATE TABLE staticMapCache (binary BLOB, date NUMERIC, scale NUMERIC, size NUMERIC, hash TEXT);", NULL, NULL, NULL);
}

- (BOOL)insertStaticMapCache:(NSData*)binary scale:(float)scale hash:(NSString*)hash {
	return [self insertTable:@"staticMapCache" binary:binary scale:scale hash:hash];
}

- (BOOL)selectStaticMapCache:(NSData**)binary scale:(float*)scale hash:(NSString*)hash {
	return [self selectTable:@"staticMapCache" binary:binary scale:scale hash:hash];
}

- (BOOL)updateStaticMapCacheDateWithHash:(NSString*)hash {
	return [self updateTable:@"staticMapCache" withHash:hash];
}

@end
