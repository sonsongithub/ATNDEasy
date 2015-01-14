//
//  LocalNotificationController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATND.h"

@interface LocalNotificationController : NSObject {
}
+ (LocalNotificationController*)sharedInstance;
- (void)addEvent:(ATNDEvent*)event;
- (void)addEvent:(ATNDEvent*)event message:(NSString*)message before:(NSTimeInterval)before;
- (NSArray*)scheduledEvents;
- (BOOL)cancelEvent:(ATNDEvent*)event;
- (BOOL)isScheduledEvent:(ATNDEvent*)event;
@end
