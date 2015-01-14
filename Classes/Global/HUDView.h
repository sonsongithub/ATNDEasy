//
//  HUDView.h
//  ATNDEasy
//
//  Created by sonson on 10/11/27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDView : UIView {
	UILabel *label;
	UIActivityIndicatorView *indicator;
}
+ (HUDView*)showHUDViewWithMessage:(NSString*)msg;
- (void)dismiss;
@end
