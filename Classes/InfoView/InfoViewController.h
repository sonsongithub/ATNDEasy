//
//  InfoViewController.h
//  2tch
//
//  Created by sonson on 09/07/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

typedef enum {
	InfoViewSKOffline		= 0,
	InfoViewSKLoading		= 1,
	InfoViewSKOnline		= 2,
	InfoViewSKInavailable	= 3
}InfoViewSKStatus;

@class Reachability;

@interface InfoViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	InfoViewSKStatus	status;
	Reachability		*hostReach;
}
+ (UINavigationController*)controllerWithNavigationController;
@end
