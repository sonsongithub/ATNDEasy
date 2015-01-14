//
//  SQLiteDatabase.h
//  2tch
//
//  Created by sonson on 09/07/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// SQLite3
#import <sqlite3.h>

@interface SQLiteDatabase : NSObject {
	sqlite3						*database;
}
+ (SQLiteDatabase*)sharedInstance;
- (void)startTransaction;
- (void)endTransaction;
- (void)initializeDatabase;
- (void)createEditableCopyOfDatabaseIfNeeded;
@end
