//
//  PlaceCell.m
//  ATNDEasy
//
//  Created by sonson on 10/11/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlaceCell.h"

#import "UIColor+Help.h"

@implementation PlaceCellContent

- (void)drawRect:(CGRect)rect {
	float leftMargin = 10;
	float centerMargin = 2;
	float rightMargin = 10;
	float fontSize = 17;
	
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	
	// draw place
	NSString *upperTitle = [event.place length] == 0 ? [NSString stringWithString:NSLocalizedString(@"Place", nil)] : [NSString stringWithString:event.place];
	CGSize upperTitleSize = [upperTitle sizeWithFont:font];
	// change color
	if ([event.place length] == 0)
		[[UIColor lightGrayColor] setFill];
	else 
		[[UIColor systemBlueColor] setFill];
	CGRect r = CGRectMake(leftMargin, (int)[PlaceCell height]/2-upperTitleSize.height-centerMargin, rect.size.width - leftMargin - rightMargin, upperTitleSize.height);
	[upperTitle drawInRect:r withFont:font lineBreakMode:UILineBreakModeTailTruncation];
	
	// draw address
	NSString *bottomTitle = [event.address length] == 0 ? [NSString stringWithString:NSLocalizedString(@"Address", nil)] : [NSString stringWithString:event.address];	
	CGSize bottomTitleSize = [bottomTitle sizeWithFont:font];
	// change color
	if ([event.address length] == 0)
		[[UIColor lightGrayColor] setFill];
	else 
		[[UIColor systemBlueColor] setFill];
	CGRect r2 = CGRectMake(leftMargin, (int)[PlaceCell height]/2+centerMargin, rect.size.width - leftMargin - rightMargin, bottomTitleSize.height);
	[bottomTitle drawInRect:r2 withFont:font lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)setEvent:(ATNDEvent*)newValue {
	event = newValue;
	[self setNeedsDisplay];
}

@end

@implementation PlaceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		content = [[PlaceCellContent alloc] initWithFrame:self.contentView.bounds];
		[content setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[self.contentView addSubview:content];
		[content release];
    }
    return self;
}

@end
