//
//  NotifyViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewController.h"

@interface NotifyViewController : MyTableViewController {
	NSMutableArray *events;
}
+ (UINavigationController*)controller;
@end
