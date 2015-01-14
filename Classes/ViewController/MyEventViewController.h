//
//  MyEventViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserViewController.h"

@interface MyEventViewController : UserViewController {
}
+ (UINavigationController*)controller;
- (BOOL)saveCache;
- (BOOL)loadCache;
- (void)reload:(id)sender;
@end
