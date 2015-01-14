//
//  SQLiteDatabase+StaticMapCache.h
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase.h"

@interface SQLiteDatabase(staticMapCache)
- (void)createTableStaticMapCache;
- (BOOL)insertStaticMapCache:(NSData*)binary scale:(float)scale hash:(NSString*)hash;
- (BOOL)selectStaticMapCache:(NSData**)binary scale:(float*)scale hash:(NSString*)hash;
- (BOOL)updateStaticMapCacheDateWithHash:(NSString*)hash;
@end
