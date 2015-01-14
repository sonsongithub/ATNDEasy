//
//  UserNameView.m
//  ATNDEasy
//
//  Created by sonson on 10/11/23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserNameView.h"

#import "ATND.h"

#define WATCH_TITLE_FONT_SIZE 18

UIFont *sharedUserNameViewFont = nil;

@implementation UserNameView

@synthesize user;

+ (UIFont*)defaultFont {
	if (sharedUserNameViewFont == nil) {
		sharedUserNameViewFont = [UIFont boldSystemFontOfSize:WATCH_TITLE_FONT_SIZE];
	}
	return sharedUserNameViewFont;
}


- (void)setHighlighted:(BOOL)newValue {
	highlighted = newValue;
	[self setNeedsDisplay];
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[self setNeedsDisplay];
}

- (void)setUser:(ATNDUser *)newValue {
	if (user != newValue) {
		user = newValue;
		CGRect r = CGRectZero;
		r.size = [user.nickname sizeWithFont:[UserNameView defaultFont]];
		[self setFrame:r];
	}
}

- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
		[self setContentMode:UIViewContentModeLeft];
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	if (highlighted)
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
	else
		CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	[user.nickname drawAtPoint:CGPointMake(0, 0) forWidth:rect.size.width withFont:[UserNameView defaultFont] lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)dealloc {
    [super dealloc];
}

@end
