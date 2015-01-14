//
//  UserViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewController.h"
#import "DownloadQueue.h"
#import "ATND.h"
#import "UserInfoView.h"

@interface UserViewController : MyTableViewController <DownloadOperationDelegate, UserInfoViewDelegate> {
	ATNDUser		*user;
	NSMutableArray	*events;
	NSMutableArray	*ownerEvents;
	
	int				eventSection;
	int				ownerSection;
	int				sections;
}
@property (nonatomic, retain) ATNDUser* user;
+ (UINavigationController*)controller;
- (void)rebuildTableInfo;
- (void)appendNewEventsToBufferFromUserInfo:(NSDictionary*)userInfo;
@end
