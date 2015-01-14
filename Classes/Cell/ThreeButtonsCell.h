//
//  TwoButtonsCell.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATND.h"

@class ThreeButtonsCell;

@protocol ThreeButtonsCellDelegate <NSObject>
- (void)didPushOpenMapButton:(ThreeButtonsCell*)sender;
- (void)didPushNotifyButton:(ThreeButtonsCell*)sender;
- (void)didPushSaveEventButton:(ThreeButtonsCell*)sender;
@end

@interface ThreeButtonsCell : UITableViewCell {
	UIButton *mapButton;
	UIButton *notifyButton;
	UIButton *calendarButton;
	ATNDEvent* event;
	id delegate;
}
@property (nonatomic, assign) id<ThreeButtonsCellDelegate> delegate;
@property (nonatomic, assign) ATNDEvent* event;
@end
