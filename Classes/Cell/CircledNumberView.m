//
//  CircledNumberView.m
//  ATNDEasy
//
//  Created by sonson on 10/11/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CircledNumberView.h"

#define CIRCLED_NUMBER_FONT_SIZE			19

#define CIRCLED_NUMBER_HORIZONTAL_MARGIN	11
#define CIRCLED_NUMBER_VERTICAL_MARGIN		1
#define CIRCLED_NUMBER_RADIUS				12

UIFont *sharedCircledNumberViewFont = nil;

@implementation CircledNumberView

+ (UIFont*)defaultFont {
	if (sharedCircledNumberViewFont == nil) {
		sharedCircledNumberViewFont = [UIFont boldSystemFontOfSize:CIRCLED_NUMBER_FONT_SIZE];
	}
	return sharedCircledNumberViewFont;
}

- (int)number {
	return number;
}

- (void)setNumber:(int)newValue {
	
	[self setHidden:!(newValue > 0)];
	
	if (number != newValue) {
		number = newValue;
		[numberString release];
		numberString = [[NSString stringWithFormat:@"%d", number] retain];
		
		CGRect r = CGRectZero;
		r.size = [numberString sizeWithFont:[CircledNumberView defaultFont]];
		r.size.width += (CIRCLED_NUMBER_HORIZONTAL_MARGIN * 2);
		r.size.height += (CIRCLED_NUMBER_VERTICAL_MARGIN * 2);
		[self setFrame:r];
	}
}

- (void)setHighlighted:(BOOL)newValue {
	highlighted = newValue;
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[self setNeedsDisplay];
}

- (id)init {
	self = [super initWithFrame:CGRectZero];
    if (self) {
		[self setContentMode:UIViewContentModeCenter];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	float radius = CIRCLED_NUMBER_RADIUS;
	
	if (highlighted)
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	else
		CGContextSetRGBFillColor(context, 139.0/255.0, 152.0/255.0, 179.0/255.0, 1);
	
	// get points
	CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
	CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	
	if (highlighted)
		CGContextSetRGBFillColor(context, 31.0/255.0, 91.0/255.0, 231.0/255.0, 1);
	else
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	[numberString drawAtPoint:CGPointMake(CIRCLED_NUMBER_HORIZONTAL_MARGIN, CIRCLED_NUMBER_VERTICAL_MARGIN) withFont:[CircledNumberView defaultFont]];
	
}

- (void)dealloc {
	[numberString release];
    [super dealloc];
}


@end
