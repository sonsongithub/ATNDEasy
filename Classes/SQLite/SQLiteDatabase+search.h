//
//  SQLiteDatabase+search.h
//  ATNDEasy
//
//  Created by sonson on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SQLiteDatabase.h"

typedef enum {
	ATNDKeywordQuery = 0,
}ANTDQueryType;

@interface SQLiteDatabase(search)
- (BOOL)insertOrUpdateWithQuery:(NSString*)query type:(ANTDQueryType)type;
- (NSArray*)candidatesWithQuery:(NSString*)query type:(ANTDQueryType)type;
- (void)deleteAllHistoryOfQuery;
@end
