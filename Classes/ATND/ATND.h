//
//  ATND.h
//  ATNDEasy
//
//  Created by sonson on 10/11/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Invaliables
extern NSString *kATNDIncommingEvent;
extern NSString *kATNDIncommingUser;
extern NSString *kATNDOperationClassName;

#define ATND_FETCH_COUNT 50

// Tool
#import "NSString+ATND.h"

// ATND
#import "ATNDEvent.h"
#import "ATNDUser.h"
#import "ATNDSearchOperation.h"

#import "ATNDNicknameSearchOperation.h"
#import "ATNDOwnerNicknameSearchOperation.h"
#import "ATNDIDSearchOperation.h"
#import "ATNDOwnerIDSearchOperation.h"
#import "ATNDEventAttendance.h"
