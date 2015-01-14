//
//  SQLiteDatabase+twitterIconCache.m
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase+twitterIconCache.h"
#import "SQLiteDatabase+ImageCache.m"

@implementation SQLiteDatabase(twitterIconCache)

- (void)createTwitterIconCache {
	sqlite3_exec(database, "CREATE TABLE twitterIconCache (binary BLOB, date NUMERIC, scale NUMERIC, size NUMERIC, hash TEXT);", NULL, NULL, NULL);
}

- (BOOL)insertTwitterIconCache:(NSData*)binary scale:(float)scale hash:(NSString*)hash {
	return [self insertTable:@"twitterIconCache" binary:binary scale:scale hash:hash];
}

- (BOOL)selectTwitterIconCache:(NSData**)binary scale:(float*)scale hash:(NSString*)hash {
	return [self selectTable:@"twitterIconCache" binary:binary scale:scale hash:hash];
}

- (BOOL)updateTwitterIconCacheDateWithHash:(NSString*)hash {
	return [self updateTable:@"twitterIconCache" withHash:hash];
}

@end
