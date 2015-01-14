//
//  SQLiteDatabase+ImageCache.h
//  ATNDEasy
//
//  Created by sonson on 10/11/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase.h"

@interface SQLiteDatabase(ImageCache)
- (int)sizeSumationOfTable:(NSString*)tableName;
- (int)countSumationOfTable:(NSString*)tableName;
- (BOOL)insertTable:(NSString*)tableName binary:(NSData*)binary scale:(float)scale hash:(NSString*)hash;
- (BOOL)selectTable:(NSString*)tableName binary:(NSData**)binary scale:(float*)scale hash:(NSString*)hash;
- (BOOL)updateTable:(NSString*)tableName withHash:(NSString*)hash;
- (double)getDateFromTable:(NSString*)tableName toBeLeftOffset:(int)countToBeLeftOffset;
- (double)deleteItemFromTable:(NSString*)tableName beforeDate:(double)dateToBeLeft;
- (BOOL)deleteSurplusOfExistingCache:(NSString*)tableName;
@end
