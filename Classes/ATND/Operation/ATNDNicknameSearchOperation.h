//
//  ATNDUserSearchOperation.h
//  ATNDEasy
//
//  Created by sonson on 10/11/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

#import "ATND.h"
#import "ATNDEventSearchOperation.h"

@interface ATNDNicknameSearchOperation : ATNDEventSearchOperation {
}
+ (ATNDNicknameSearchOperation*)operationWithSearchNickname:(NSString*)nickname start:(int)start;
@end
