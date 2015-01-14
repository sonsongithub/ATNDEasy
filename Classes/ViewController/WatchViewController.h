//
//  WatchViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewController.h"
#import "DownloadOperation.h"

@interface WatchViewController : MyTableViewController <DownloadOperationDelegate> {
	int checkCounter;
	UIProgressView *progress;
}
+ (UINavigationController*)controller;
@end
