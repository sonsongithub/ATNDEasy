//
//  SQLiteDatabase+twitterIconCache.h
//  ATNDEasy
//
//  Created by sonson on 10/11/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDatabase.h"

@interface SQLiteDatabase(twitterIconCache)
- (void)createTwitterIconCache;
- (BOOL)insertTwitterIconCache:(NSData*)binary scale:(float)scale hash:(NSString*)hash;
- (BOOL)selectTwitterIconCache:(NSData**)binary scale:(float*)scale hash:(NSString*)hash;
- (BOOL)updateTwitterIconCacheDateWithHash:(NSString*)hash;
@end
