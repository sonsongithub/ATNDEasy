//
//  EventCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventCell.h"

#import "NSDateFormatter+ATND.h"
#import "UIColor+Help.h"

@implementation EventCellContent

- (void)setHighlighted:(BOOL)newValue {
	highlighted = newValue;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	float leftMargin = 20;
	float rightMargin = 10;
	float centerMargin = 5;
	
	////////////////////////////////////////////////////////////////////////////////
	// render title string
	float titleFontSize = 17;
	
	// whether past event is rendered especial color.
	BOOL isPastColor = [event isPast] && ([[NSUserDefaults standardUserDefaults] integerForKey:@"atnd_past_event"] == 1);
	
	// 
	UIFont *titleFont = [UIFont boldSystemFontOfSize:titleFontSize];
	
	// title
	CGSize titleSize = [event.title sizeWithFont:titleFont];
	
	if (highlighted)
		[[UIColor whiteColor] setFill];
	else if (isPastColor)
		[[UIColor lightGrayColor] setFill];
	else
		[[UIColor blackColor] setFill];
	CGRect titleRect = CGRectMake(leftMargin, (int)[EventCell height]/2 - titleSize.height-centerMargin, rect.size.width - leftMargin - rightMargin, titleSize.height);
	[event.title drawInRect:titleRect withFont:titleFont lineBreakMode:UILineBreakModeTailTruncation];
	
	////////////////////////////////////////////////////////////////////////////////
	// render date string
	float valueFontSize = 12;
	UIFont *valueFont = [UIFont boldSystemFontOfSize:valueFontSize];
	
	NSDateFormatter *fromFormat = [NSDateFormatter normalDescriptionFormatter];
	NSString *dateString = [fromFormat stringFromDate:event.started_at];

	CGSize dateSize = [dateString sizeWithFont:valueFont];
	CGRect dateRect = CGRectMake(leftMargin, titleRect.origin.y + titleRect.size.height + 1, rect.size.width - leftMargin - rightMargin, dateSize.height);
	
	if (highlighted)
		[[UIColor whiteColor] setFill];
	else if (isPastColor)
		[[UIColor lightGrayColor] setFill];
	else
		[[UIColor systemBlueColor] setFill];

	[dateString drawInRect:dateRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation];
	
	////////////////////////////////////////////////////////////////////////////////
	// render place string
	NSString *placeString = [event.place length] > 0 ? event.place : NSLocalizedString(@"Place", nil);
	CGSize placeSize = [placeString sizeWithFont:valueFont];
	CGRect placeRect = CGRectMake(leftMargin, dateRect.origin.y + dateRect.size.height + 1, rect.size.width - leftMargin - rightMargin, placeSize.height);
	
	if (highlighted)
		[[UIColor whiteColor] setFill];
	else if (isPastColor)
		[[UIColor lightGrayColor] setFill];
	else if ([event.place length] == 0)
		[[UIColor lightGrayColor] setFill];
	else
		[[UIColor systemBlueColor] setFill];
	[placeString drawInRect:placeRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation];

	////////////////////////////////////////////////////////////////////////////////
	// unread icon
	if (event.unread && ![event isPast]) {
		UIImage *unreadIcon = [UIImage imageNamed:@"unread.png"];
		UIImage *unreadIconSelected = [UIImage imageNamed:@"unread_selected.png"];
		CGPoint unreadPoint = CGPointMake(5, (int)(self.frame.size.height - unreadIcon.size.height)/2);
		if (highlighted)
			[unreadIconSelected drawAtPoint:unreadPoint];
		else
			[unreadIcon drawAtPoint:unreadPoint];
	}
}

@end

@implementation EventCell

+ (float)height {
	return 65;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[content setHighlighted:highlighted];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		content = [[EventCellContent alloc] initWithFrame:self.contentView.bounds];
		[content setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		[self.contentView addSubview:content];
		[content release];
		[self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    return self;
}

@end