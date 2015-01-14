//
//  UserNameView.h
//  ATNDEasy
//
//  Created by sonson on 10/11/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATNDUser;

@interface UserNameView : UIView {
	ATNDUser	*user;
	BOOL		highlighted;
}
@property (nonatomic, assign) ATNDUser *user;
- (void)setHighlighted:(BOOL)newValue;
@end
