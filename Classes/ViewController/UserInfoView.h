//
//  UserInfoView.h
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATND.h"

@class UserInfoView;
@class UserIconView;

@protocol UserInfoViewDelegate <NSObject>
- (void)didPushWatchButton:(UserInfoView*)sender;
@end


@interface UserInfoView : UIView {
	UserIconView				*iconView;
	UIButton					*watchButton;
	id<UserInfoViewDelegate>	delegate;
}
@property (nonatomic, assign) id<UserInfoViewDelegate>	delegate;
- (void)setUser:(ATNDUser *)newValue;
@end
