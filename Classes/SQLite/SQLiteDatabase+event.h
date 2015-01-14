//
//  SQLiteDatabase+event.h
//  ATNDEasy
//
//  Created by sonson on 10/11/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SQLiteDatabase.h"
#import "ATND.h"

@interface SQLiteDatabase(event)
- (NSArray*)eventIDs;
- (BOOL)deleteEventID:(int)event_id;
- (BOOL)isInsertedEvent:(ATNDEvent*)event;
- (ATNDEvent*)eventOfEventID:(int)event_id;
- (NSArray*)events;
- (BOOL)insertOrUpdateWithEvent:(ATNDEvent*)event;
@end
