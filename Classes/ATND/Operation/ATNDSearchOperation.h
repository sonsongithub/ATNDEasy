//
//  ATNDSearchOperation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

#import "ATND.h"
#import "ATNDEventSearchOperation.h"

@interface ATNDSearchOperation : DownloadOperation {
}
+ (ATNDSearchOperation*)operationWithSearchKeyword:(NSString*)keyword start:(int)start;
@end
