//
//  UserListViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewController.h"
#import "DownloadOperation.h"
#import "ATND.h"

@interface UserListViewController : MyTableViewController <DownloadOperationDelegate> {
	ATNDEvent *event;

	NSMutableArray *accepted;
	NSMutableArray *waiting;
}
@property (nonatomic, retain) ATNDEvent* event;
@end
