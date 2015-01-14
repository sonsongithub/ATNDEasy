//
//  ATNDEventAttendance.h
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownloadOperation.h"
#import "ATND.h"

@interface ATNDEventAttendance : DownloadOperation {
}
+ (ATNDEventAttendance*)operationWithAttendanceEventID:(int)eventID start:(int)start;
@end
