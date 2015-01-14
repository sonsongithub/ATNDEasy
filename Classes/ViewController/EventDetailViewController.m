//
//  EventDetailViewController.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventDetailViewController.h"

#import "DownloadQueue.h"

#import "MapViewCell.h"
#import "StaticMapViewCell.h"
#import "ThreeButtonsCell.h"
#import "DescriptionCell.h"

#import "UserViewController.h"
#import "UserListViewController.h"
#import "UIViewController+LongTitle.h"

#import "SQLiteDatabase+event.h"
#import "SQLiteDatabase+history.h"
#import "LocalNotificationController.h"

#import "DateCell.h"
#import "PlaceCell.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

#import "DropAnimation.h"
#import "WatchList.h"

#import "WebViewController.h"

@implementation EventDetailViewController

@synthesize event;

#pragma mark -
#pragma mark Instance method

- (void)drop {
	UIView *p = self.navigationItem.titleView;
	
	if ([p isKindOfClass:[UILabel class]]) {
		UILabel *existing = (UILabel*)p;
		UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		[titleLabel setFont:existing.font];
		[titleLabel setTextColor:existing.textColor];
		[titleLabel setShadowColor:existing.shadowColor];
		[titleLabel setBackgroundColor:existing.backgroundColor];
		[titleLabel setNumberOfLines:existing.numberOfLines];
		[titleLabel setText:existing.text];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		
		CGRect r = [[existing superview] convertRect:existing.frame toView:[[UIApplication sharedApplication] keyWindow]];
		
		[titleLabel setFrame:r];
		p = titleLabel;
		[[[UIApplication sharedApplication] keyWindow] addSubview:p];
	}
	else if (p == nil) {
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setShadowColor:[UIColor grayColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setText:self.title];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[titleLabel setFrame:CGRectMake(0, 20, 320, 44)];
		
		p = titleLabel;
		[[[UIApplication sharedApplication] keyWindow] addSubview:p];
	}
	
	[(UILabel*)p setTextColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
	[(UILabel*)p setShadowColor:[UIColor blackColor]];
	
	CAAnimation *movingAnimation = movingAnimationForView(p, 270);
	CAAnimation *sizeAnimation = sizeAnimationForViewAndRatio(p, 0.2, 0.4);
	CAAnimation *rotateAnimation = rotateAnimationForView(p);
	
	// make group
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:movingAnimation, sizeAnimation, rotateAnimation, nil];
	group.duration = 0.8;
	group.removedOnCompletion = YES;
	group.fillMode = kCAFillModeForwards;
	group.delegate = self;
	
	// set context
	[group setValue:p forKey:@"context"];
	
	// commit animation
	[p.layer addAnimation:group forKey:@"hoge"];

}

- (void)addLocalNotification:(id)sender {
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Notify", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										 destructiveButtonTitle:nil
											  otherButtonTitles:nil];
	
	NSMutableArray *buttons = [NSMutableArray array];
	
	NSDate *eventDate = event.started_at;
	
	if ([eventDate timeIntervalSinceReferenceDate] - now > 3600 * 24)
		[buttons addObject:NSLocalizedString(@"1 day before", nil)];
	if ([eventDate timeIntervalSinceReferenceDate] - now > 3600 * 12)
		[buttons addObject:NSLocalizedString(@"12 hours before", nil)];
	if ([eventDate timeIntervalSinceReferenceDate] - now > 3600)
		[buttons addObject:NSLocalizedString(@"1 hour before", nil)];
	
	for (NSString *title in [buttons reverseObjectEnumerator]) {
		[sheet addButtonWithTitle:title];
	}
	if (self.tabBarController.tabBar)
		[sheet showFromTabBar:self.tabBarController.tabBar];
	else 
		[sheet showInView:self.view];
	[sheet release];
}

- (void)updateSection {
	BOOL enabledMap = !(event.lat == 0 && event.lon == 0);
	BOOL enabledDesc = ([event.description length] > 0);
	
	infoSection = 0;
	memberSection = 1;
	mapSection = -1;
	twoButtonSection = -1;
	descriptionSection = -1;
	safariSection = -1;
	
	if (enabledMap && enabledDesc) {
		sections = 6;
		mapSection = 2;
		twoButtonSection = 3;
		descriptionSection = 4;
		safariSection = 5;
	}
	if (enabledMap && !enabledDesc) {
		sections = 5;
		
		mapSection = 2;
		twoButtonSection = 3;
		safariSection = 4;
	}
	if (!enabledMap && enabledDesc) {
		sections = 5;
		twoButtonSection = 2;
		descriptionSection = 3;
		safariSection = 4;
	}
	if (!enabledMap && !enabledDesc) {
		sections = 4;
		twoButtonSection = 2;
		safariSection = 3;
	}
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Accessor

- (void)setEvent:(ATNDEvent *)newValue {
	if (event != newValue) {
		[event release];
		event = [newValue retain];
		
		[self updateSection];
	}
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization.
		isExpandedDescription = NO;
    }
    return self;
}

- (id)init {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization.
		isExpandedDescription = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setAdMakerAdToHeaderView];
	[self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease]];
	[[SQLiteDatabase sharedInstance] insertOrUpdateHistoryWithEventID:event.event_id];
	[self setLongTitle:event.title];
	[[WatchList sharedInstance] updateNumberOfUnread];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)button {
	if (button == 0) {
		DNSLog(@"cancel");
		return;
	}
	else if (button == 1) {
		[[LocalNotificationController sharedInstance] addEvent:event message:NSLocalizedString(@"in 1 hour", nil) before:3600];
		DNSLog(@"1 hour");
	}
	else if (button == 2) {
		[[LocalNotificationController sharedInstance] addEvent:event message:NSLocalizedString(@"in 12 hours", nil) before:3600*12];
		DNSLog(@"12 hours");
	}
	else if (button == 3) {
		[[LocalNotificationController sharedInstance] addEvent:event message:NSLocalizedString(@"in 1 day", nil) before:3600*24];
		DNSLog(@"1 day");
	}
	[self.tableView reloadData];
	
	if (self.tabBarController)
		[self drop];
}

#pragma mark -
#pragma mark DownloadOperationDelegate

- (void)didDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
	DNSLogMethod
}

- (void)failedDownloadOperation:(DownloadOperation*)queue {
}

- (void)failedDownloadOperation:(DownloadOperation*)queue userInfo:(NSDictionary*)userInfo {
}

#pragma mark -
#pragma mark ThreeButtonsCellDelegate 

- (void)didPushOpenMapButton:(ThreeButtonsCell*)sender {
	DNSLogMethod
	NSString *placeName = [event.place length] ? event.place : NSLocalizedString(@"Place", nil);
	NSString *URLString = [NSString stringWithFormat:@"http://maps.google.com/maps?z=%d&q=%@@%f,%f", 14, placeName, event.lat, event.lon];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)didPushNotifyButton:(ThreeButtonsCell*)sender {
	DNSLogMethod
	[self addLocalNotification:nil];
}

- (void)didPushSaveEventButton:(ThreeButtonsCell*)sender {
	EKEventStore *store = [[EKEventStore alloc] init];
	
	EKCalendar *cal = [store defaultCalendarForNewEvents];
	
	EKEvent *eventToBeSaved = [EKEvent eventWithEventStore:store];
	
	[eventToBeSaved setCalendar:cal];
	[eventToBeSaved setTitle:event.title];
	[eventToBeSaved setStartDate:event.started_at];
	[eventToBeSaved setEndDate:event.ended_at];
	[eventToBeSaved setLocation:event.place];
	
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	addController.eventStore = store;
	addController.event = eventToBeSaved;
	[self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
	[addController release];
	
	[store release];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller 
		  didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == safariSection) {
		
		UIView *dummy = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)] autorelease];
		[dummy setBackgroundColor:[UIColor clearColor]];
		
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		//[label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[label setNumberOfLines:3];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		[label setText:NSLocalizedString(@"ATND does not support login API. You have to use a web browser if you'd like to edit your attendance.", nil)];
		CGRect b =[label textRectForBounds:CGRectMake(0, 0, 280, 300) limitedToNumberOfLines:4];
		b.origin.x = (int)(dummy.frame.size.width - b.size.width)/2;
		b.origin.y = (int)(dummy.frame.size.height - b.size.height)/2;
		[label setFrame:b];
		[dummy addSubview:label];
		return dummy;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == safariSection) {
		return 80;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == infoSection) {
		return 2;
	}
	if (section == memberSection) {
		return 2;
	}
	if (section == mapSection) {
		if (event.lat == 0.0 && event.lon == 0.0)
			return 0;
		return 1;
	}
	if (section == twoButtonSection) {
		return 1;
	}
	if (section == descriptionSection) {
		if ([event heightOfDescription] > 100) {
			return 2;
		}
		else {
			isExpandedDescription = NO;
			return 1;
		}
	}
	if (section == safariSection) {
		return 1;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == mapSection) {
		return StaticMapViewCellHeight;
	}
	if (indexPath.section == descriptionSection) {
		if (indexPath.row == 0) {
			if (isExpandedDescription)
				return [event heightOfDescription] + 20;
			return [event heightOfTruncatedDescription] + 20;
		}
	}
	if (indexPath.section == infoSection && indexPath.row == 0) {
		return [DateCell height];
	}
	if (indexPath.section == infoSection && indexPath.row == 1) {
		return [PlaceCell height];
	}
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == infoSection && indexPath.row == 0) {
		static NSString *CellIdentifier = @"DateCell";
		
		DateCell *cell = (DateCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[DateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		[tableView setSeparatorColor:[UIColor lightGrayColor]];
		
		[cell setEvent:event];
    
		return cell;
	}
	if (indexPath.section == infoSection) {
		static NSString *CellIdentifier = @"PlaceCell";
		PlaceCell *cell = (PlaceCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell setEvent:event];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		[tableView setSeparatorColor:[UIColor lightGrayColor]];
		return cell;
	}
	if (indexPath.section == memberSection) {
		static NSString *CellIdentifier = @"Cell3";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		if (indexPath.row == 0) {
			[cell.textLabel setText:NSLocalizedString(@"Capacity", nil)];
			[cell.detailTextLabel setText:[NSString stringWithFormat:@"%d/%d", event.accepted, event.limit]];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[tableView setSeparatorColor:[UIColor lightGrayColor]];
			return cell;
		}
		if (indexPath.row == 1) {
			[cell.textLabel setText:NSLocalizedString(@"Owner", nil)];
			[cell.detailTextLabel setText:event.owner_nickname];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[tableView setSeparatorColor:[UIColor lightGrayColor]];
			return cell;
		}
	}
	if (indexPath.section == mapSection) {
		if (mapViewCell == nil) {
			mapViewCell = [[StaticMapViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MapViewCell"];
			DNSLog(@"%f,%f", event.lat, event.lon);
			// mapViewCell = [[MapViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MapViewCell"];
			[mapViewCell setLatitude:event.lat longitude:event.lon];
		}
		[tableView setSeparatorColor:[UIColor lightGrayColor]];
		return mapViewCell;
	}
	if (indexPath.section == twoButtonSection) {
		if (twoButtonsCell == nil) {
			twoButtonsCell = [[ThreeButtonsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ThreeButtonsCell"];
		}
		
		[twoButtonsCell setDelegate:self];
		[twoButtonsCell setEvent:event];
		
		[tableView setSeparatorColor:[UIColor clearColor]];
		return twoButtonsCell;
	}
	if (indexPath.section == descriptionSection) {
		if (indexPath.row == 0) {
			if (descriptionCell == nil) {
				descriptionCell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DescriptionCell"];
			}
			[descriptionCell setIsExpanded:isExpandedDescription];
			[descriptionCell setDescription:event.propotionalDescription];
			[tableView setSeparatorColor:[UIColor lightGrayColor]];
			return descriptionCell;
		}
		if (indexPath.row == 1) {
			static NSString *CellIdentifier = @"CenteringCell";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				[cell.textLabel setTextAlignment:UITextAlignmentCenter];
			}
			[tableView setSeparatorColor:[UIColor lightGrayColor]];
			if (isExpandedDescription) {
				[cell.textLabel setText:NSLocalizedString(@"Close", nil)];
			}
			else {
				[cell.textLabel setText:NSLocalizedString(@"Expand", nil)];
			}
			return cell;
		}
	}
	if (indexPath.section == safariSection) {
		static NSString *CellIdentifier = @"CenteringCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			[cell.textLabel setTextAlignment:UITextAlignmentCenter];
		}
		
		[tableView setSeparatorColor:[UIColor lightGrayColor]];
		if (indexPath.row == 0) {
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"atnd_use_safari"]) {
				[cell.textLabel setText:NSLocalizedString(@"Open with Safari", nil)];
			}
			else {
				[cell.textLabel setText:NSLocalizedString(@"Open with Browser", nil)];
			}
		}
		return cell;
	}
	
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == memberSection) {
		if (indexPath.row == 0) {
			UserListViewController *controller = [[UserListViewController alloc] init];
			[controller setEvent:event];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		if (indexPath.row == 1) {
			UserViewController *controller = [[UserViewController alloc] init];
			ATNDUser *user = [[ATNDUser alloc] init];
			[user setTwitter_id:event.owner_twitter_id];
			[user setNickname:event.owner_nickname];
			[user setTwitter_img:event.owner_twitter_img];
			[user setUser_id:event.owner_id];
			[controller setUser:user];
			[user release];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
	if (indexPath.section == descriptionSection) {
		if (indexPath.row == 1) {
			isExpandedDescription = !isExpandedDescription;
			[self.tableView reloadData];
		}
	}
	if (indexPath.section == safariSection) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"atnd_use_safari"]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:event.event_url]];
		}
		else {
			UINavigationController *p = [WebViewController sharedNavigationController];
			[[WebViewController sharedInstance] openURLString:event.event_url];
			[self presentModalViewController:p animated:YES];
		}
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[mapViewCell release];
	[twoButtonsCell release];
	[descriptionCell release];
	[event release];
    [super dealloc];
}

@end

