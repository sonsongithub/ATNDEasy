//
//  EventDetailViewController.h
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "MyTableViewController.h"
#import "DownloadOperation.h"
#import "ATND.h"
#import "ThreeButtonsCell.h"

@class MapViewCell;
@class StaticMapViewCell;
@class ThreeButtonsCell;
@class DescriptionCell;

@interface EventDetailViewController : MyTableViewController <DownloadOperationDelegate, EKEventEditViewDelegate, ThreeButtonsCellDelegate, UIActionSheetDelegate> {
	ATNDEvent			*event;
	
	// original cell
	StaticMapViewCell	*mapViewCell;
	ThreeButtonsCell	*twoButtonsCell;
	DescriptionCell		*descriptionCell;
	
	BOOL				isExpandedDescription;
	
	int					sections;
	int					infoSection;
	int					memberSection;
	int					mapSection;
	int					twoButtonSection;
	int					descriptionSection;
	int					safariSection;
}
@property (nonatomic, retain) ATNDEvent *event;
@end
