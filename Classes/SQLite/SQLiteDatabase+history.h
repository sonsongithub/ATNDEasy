//
//  SQLiteDatabase+history.h
//  ATNDEasy
//
//  Created by sonson on 10/11/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDatabase.h"

@interface SQLiteDatabase(history)
- (void)deleteAllHistory;
- (BOOL)insertOrUpdateHistoryWithEventID:(int)event_id;
- (NSTimeInterval)timeIntervalOfEventID:(int)event_id;
@end
