//
//  NSDateFormatter+ATND.h
//  ATNDEasy
//
//  Created by sonson on 10/11/17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter(ATND)
+ (NSDateFormatter*)W3CFormatter;
+ (NSDateFormatter*)normalDescriptionFormatter;
+ (NSDateFormatter*)shortDescriptionFormatter;
@end
