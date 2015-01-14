//
//  TwoButtonsCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ThreeButtonsCell.h"

#import "LocalNotificationController.h"

#define TwoButtonsCellButtonWidth 95

@implementation ThreeButtonsCell

@synthesize event, delegate;

#pragma mark -
#pragma mark UIButton call bacck

- (void)pushOpenMap:(id)sender {
	DNSLogMethod
	if ([delegate respondsToSelector:@selector(didPushOpenMapButton:)]) {
		[delegate didPushOpenMapButton:self];
	}
}

- (void)pushNotify:(id)sender {
	DNSLogMethod
	if ([delegate respondsToSelector:@selector(didPushNotifyButton:)]) {
		[delegate didPushNotifyButton:self];
	}
	[notifyButton setEnabled:![[LocalNotificationController sharedInstance] isScheduledEvent:event]];
}

- (void)pushSaveCalendar:(id)sender {
	DNSLogMethod
	if ([delegate respondsToSelector:@selector(didPushSaveEventButton:)]) {
		[delegate didPushSaveEventButton:self];
	}
}

- (void)setEvent:(ATNDEvent *)newValue {
	event = newValue;	
	[mapButton setEnabled:!(event.lat == 0 && event.lon == 0)];
	[notifyButton setEnabled:(![[LocalNotificationController sharedInstance] isScheduledEvent:event] && ([event.started_at timeIntervalSinceReferenceDate] > [NSDate timeIntervalSinceReferenceDate]))];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// cell initializing
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundColor:[UIColor clearColor]];
		
		float horizontalMargin = (int)(self.contentView.frame.size.width - TwoButtonsCellButtonWidth*3)/2;
		float mapButtonFontSize = 12;
		float notifyButtonFontSize = 12;
		float calendarButtonFontSize = 12;
		
		// map button
		mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[mapButton setFrame:CGRectZero];
		[mapButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		[mapButton setTitle:NSLocalizedString(@"Open Map", nil) forState:UIControlStateNormal];
		[mapButton addTarget:self action:@selector(pushOpenMap:) forControlEvents:UIControlEventTouchUpInside];
		[mapButton.titleLabel setFont:[UIFont boldSystemFontOfSize:mapButtonFontSize]];

		// notification button
		notifyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[notifyButton setFrame:CGRectZero];
		[notifyButton.titleLabel setNumberOfLines:2];
		[notifyButton.titleLabel setTextAlignment:UITextAlignmentCenter];
		[notifyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		[notifyButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[notifyButton setTitle:NSLocalizedString(@"Already scheduled", nil) forState:UIControlStateDisabled];
		[notifyButton setTitle:NSLocalizedString(@"Notify this event", nil) forState:UIControlStateNormal];
		[notifyButton addTarget:self action:@selector(pushNotify:) forControlEvents:UIControlEventTouchUpInside];
		[notifyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:notifyButtonFontSize]];
		
		// calendar button
		calendarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[calendarButton setFrame:CGRectZero];
		[calendarButton.titleLabel setNumberOfLines:2];
		[calendarButton.titleLabel setTextAlignment:UITextAlignmentCenter];
		[calendarButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[calendarButton setTitle:NSLocalizedString(@"Save into calender", nil) forState:UIControlStateNormal];
		[calendarButton addTarget:self action:@selector(pushSaveCalendar:) forControlEvents:UIControlEventTouchUpInside];
		[calendarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:calendarButtonFontSize]];
		
		[self.contentView addSubview:mapButton];
		[self.contentView addSubview:notifyButton];
		[self.contentView addSubview:calendarButton];
		
		[mapButton setFrame:CGRectMake(0, 0, TwoButtonsCellButtonWidth, 44)];
		[notifyButton setFrame:CGRectMake(TwoButtonsCellButtonWidth + horizontalMargin, 0, TwoButtonsCellButtonWidth, 44)];
		[calendarButton setFrame:CGRectMake(2*(TwoButtonsCellButtonWidth + horizontalMargin), 0, TwoButtonsCellButtonWidth, 44)];
    }
    return self;
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end
