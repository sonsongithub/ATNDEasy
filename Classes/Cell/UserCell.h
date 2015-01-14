//
//  UserCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATND.h"

@class UserNameView;
@class UserIconView;
@class CircledNumberView;

@interface UserCell : UITableViewCell {
	UserIconView		*iconView;
	CircledNumberView	*numberView;
	UserNameView		*nameView;
}
- (void)setUser:(ATNDUser *)newValue;
@end
