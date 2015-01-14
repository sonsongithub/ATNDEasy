//
//  EventBaseCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATND.h"

@interface EventBaseContent : UIView {
	ATNDEvent *event;
}
- (void)setEvent:(ATNDEvent*)newValue;
- (void)setHighlighted:(BOOL)newValue;
@end

@interface EventBaseCell : UITableViewCell {
	EventBaseContent *content;
}
+ (float)height;
- (void)setEvent:(ATNDEvent*)newValue;
@end
