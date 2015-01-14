//
//  MyTableViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTableViewController : UITableViewController {
	UIView *loadingView;
}
- (void)showLoadingMessage;
- (void)hideLoadingMessage;
- (void)setAdMakerAdToHeaderView;
@end
