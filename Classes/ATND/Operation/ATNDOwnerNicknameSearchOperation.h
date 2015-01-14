//
//  ATNDOwnerNicknameSearchOperation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadOperation.h"

#import "ATND.h"
#import "ATNDEventSearchOperation.h"

@interface ATNDOwnerNicknameSearchOperation : ATNDEventSearchOperation {
}
+ (ATNDOwnerNicknameSearchOperation*)operationWithSearchNickname:(NSString*)nickname start:(int)start;
@end
