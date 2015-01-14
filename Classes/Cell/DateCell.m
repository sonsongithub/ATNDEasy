//
//  DateCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateCell.h"

#import "NSDateFormatter+ATND.h"
#import "UIColor+Help.h"

@implementation DateCellContent

- (void)drawRect:(CGRect)rect {
	float leftMargin = 10;
	float rightMargin = 10;
	float centerMargin = 2;
	float fontSize = 17;
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:fontSize ];
	
	// render left title strings
	NSString *upperTitle = [NSString stringWithString:NSLocalizedString(@"Starts", nil)];
	NSString *bottomTitle = [NSString stringWithString:NSLocalizedString(@"Ends", nil)];
	
	CGSize upperTitleSize = [upperTitle sizeWithFont:titleFont];
	
	[upperTitle drawAtPoint:CGPointMake(leftMargin, (int)[DateCell height]/2 - upperTitleSize.height-centerMargin) withFont:titleFont];
	[bottomTitle drawAtPoint:CGPointMake(leftMargin, (int)[DateCell height]/2 + centerMargin) withFont:titleFont];
	
	// render right value strings
	UIFont *valueFont = [UIFont systemFontOfSize:fontSize ];
	
	// check length of the event
	NSTimeInterval start = [event.started_at timeIntervalSinceReferenceDate];
	NSTimeInterval end = [event.ended_at timeIntervalSinceReferenceDate];
	long int start_date = (long int)start - (long int)start % (3600 * 24);
	long int end_date = (long int)end - (long int)end % (3600 * 24);
	BOOL overDay = (start_date == end_date);
	
	// alloc and set date formatter
	NSDateFormatter *fromFormat = nil;
	NSDateFormatter *toFormat = nil;
	if (overDay)  {
		fromFormat = [NSDateFormatter normalDescriptionFormatter];
		toFormat = [NSDateFormatter shortDescriptionFormatter];
	}
	else {
		fromFormat = [NSDateFormatter normalDescriptionFormatter];
		toFormat = [NSDateFormatter normalDescriptionFormatter];
	}
	
	// make value strings
	NSString *from = [fromFormat stringFromDate:event.started_at];
	NSString *to = [toFormat stringFromDate:event.ended_at];
	
	// render
	CGSize fromStringSize = [from sizeWithFont:valueFont];
	CGSize toStringSize = [to sizeWithFont:valueFont];
	
	[[UIColor systemBlueColor] setFill];
	
	[from drawAtPoint:CGPointMake(rect.size.width - fromStringSize.width - rightMargin, (int)[DateCell height]/2 - fromStringSize.height - centerMargin) withFont:valueFont];
	[to drawAtPoint:CGPointMake(rect.size.width - toStringSize.width - rightMargin, (int)[DateCell height]/2 + centerMargin) withFont:valueFont];
}

@end

@implementation DateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		content = [[DateCellContent alloc] initWithFrame:self.contentView.bounds];
		[content setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[self.contentView addSubview:content];
		[content release];
    }
    return self;
}

@end
