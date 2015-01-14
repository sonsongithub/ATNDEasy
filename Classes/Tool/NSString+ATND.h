//
//  NSString+ATND.h
//  ATNDEasy
//
//  Created by sonson on 10/11/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(ATND)
- (NSString*)stringByRemovingHTMLTags;
- (NSDate*)dateWithW3CFormat;
@end
